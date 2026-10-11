import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/bz_colors.dart';
import '../../core/excel/workbook_service.dart';
import '../../core/platform.dart';
import '../../core/providers.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

/// Shared actions for the Excel workbook: create, open, read back, share.
/// Used by the settings section and by the first-launch prompt.

const _xlsxGroup = XTypeGroup(
  label: 'Excel workbook',
  extensions: ['xlsx'],
  mimeTypes: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
  uniformTypeIdentifiers: ['org.openxmlformats.spreadsheetml.sheet'],
);

String _summary(ImportResult? r) {
  if (r == null || r.total == 0) return 'Your data will be written to it as you work.';
  return 'Read ${r.total} rows from the file${r.errors.isEmpty ? '' : ' · ${r.errors.length} rows skipped'}.';
}

/// Creates a new workbook (desktop: choose where; phone: inside the app) and
/// links the app to it.
Future<bool> createWorkbook(BuildContext context, WidgetRef ref) async {
  final svc = ref.read(workbookProvider);
  String? target;
  try {
    if (AppPlatform.isDesktop) {
      final suggested = await svc.defaultPath();
      final location = await getSaveLocation(
        confirmButtonText: 'Save workbook',
        suggestedName: WorkbookService.fileName,
        initialDirectory: p.dirname(suggested),
        acceptedTypeGroups: const [_xlsxGroup],
      );
      target = location?.path;
      if (target == null) return false;
      if (!target.toLowerCase().endsWith('.xlsx')) target = '$target.xlsx';
    } else {
      target = await svc.defaultPath();
    }
    final imported = await svc.connect(target);
    BzToasts.success('Workbook connected', message: _summary(imported));
    return true;
  } catch (e) {
    BzToasts.error('Could not create the workbook', message: '$e');
    return false;
  }
}

/// Opens an existing .xlsx. On desktop the file itself becomes the live
/// workbook; on phones its rows are read into the app's own workbook.
Future<bool> openExistingWorkbook(BuildContext context, WidgetRef ref) async {
  final svc = ref.read(workbookProvider);
  try {
    final file = await openFile(confirmButtonText: 'Open workbook', acceptedTypeGroups: const [_xlsxGroup]);
    final path = file?.path;
    if (path == null) return false;
    if (AppPlatform.isDesktop) {
      final imported = await svc.connect(path);
      BzToasts.success('Workbook connected', message: _summary(imported));
    } else {
      final imported = await svc.importFrom(path);
      if (!svc.isConfigured) {
        await svc.connect(await svc.defaultPath());
      } else {
        await svc.syncNow();
      }
      BzToasts.success('Workbook read', message: _summary(imported));
    }
    return true;
  } catch (e) {
    BzToasts.error('Could not open the workbook', message: '$e');
    return false;
  }
}

/// Reads the linked workbook back into the app (after edits made in Excel).
Future<void> readWorkbookNow(BuildContext context, WidgetRef ref) async {
  final svc = ref.read(workbookProvider);
  final path = svc.path;
  if (path == null) return;
  try {
    final r = await svc.importFrom(path);
    await svc.syncNow();
    BzToasts.success('Workbook read', message: _summary(r));
  } catch (e) {
    BzToasts.error('Could not read the workbook', message: '$e');
  }
}

/// Phones: hand the workbook to WhatsApp, Drive, Mail…
Future<void> shareWorkbook(BuildContext context, WidgetRef ref) async {
  final svc = ref.read(workbookProvider);
  final path = svc.path;
  if (path == null) return;
  await svc.syncNow();
  await SharePlus.instance.share(ShareParams(files: [XFile(path)], subject: 'FrameWorkz workbook'));
}

/// Desktop: open the folder that holds the workbook.
Future<void> revealWorkbook(WidgetRef ref) async {
  final path = ref.read(workbookProvider).path;
  if (path == null) return;
  await launchUrl(Uri.file(p.dirname(path)));
}

/// First-launch prompt: asks the user to link a workbook before they start.
Future<void> showWorkbookPrompt(BuildContext context, WidgetRef ref) async {
  final theme = Theme.of(context);
  await showBzModal<void>(
    context: context,
    title: 'Keep everything in Excel',
    subtitle: 'FrameWorkz saves your work in a workbook you own.',
    icon: BootstrapIcons.file_earmark_excel,
    width: 520,
    child: Consumer(builder: (context, ref, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppPlatform.isDesktop
                ? 'Pick where the FrameWorkz.xlsx file should live. Every lead, client, project, follow-up and invoice is written to it as you work, and you can open it in Excel any time.'
                : 'FrameWorkz keeps a FrameWorkz.xlsx file on this phone and updates it as you work. You can share it to Drive, WhatsApp or email whenever you like.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          BzActionRow([
            BzButton(
              label: 'Open existing…',
              icon: BootstrapIcons.folder2_open,
              variant: BzVariant.light,
              onPressed: () async {
                final ok = await openExistingWorkbook(context, ref);
                if (ok && context.mounted) Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            BzButton(
              label: 'Create workbook',
              icon: BootstrapIcons.plus_lg,
              onPressed: () async {
                final ok = await createWorkbook(context, ref);
                if (ok && context.mounted) Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BzButton(label: 'Not now', link: true, variant: BzVariant.secondary, size: BzSize.sm, onPressed: () => Navigator.of(context, rootNavigator: true).pop()),
              const SizedBox(width: 8),
              BzButton(
                label: "Don't ask again",
                link: true,
                variant: BzVariant.secondary,
                size: BzSize.sm,
                onPressed: () {
                  ref.setSetting(Keys.workbookPromptOff, 'true');
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        ],
      );
    }),
  );
}

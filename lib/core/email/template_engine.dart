import '../db/database.dart';
import '../settings/app_settings.dart';
import '../utils/format.dart';

/// Renders `{{placeholder}}` templates and wraps plain text into a branded
/// HTML email.
class TemplateEngine {
  TemplateEngine._();

  static final RegExp _tag = RegExp(r'\{\{\s*([a-zA-Z0-9_]+)\s*\}\}');

  /// Replaces every `{{key}}` with its value; unknown keys become empty.
  static String render(String template, Map<String, String> vars) {
    return template.replaceAllMapped(_tag, (m) => vars[m.group(1)!] ?? '');
  }

  /// Placeholders the editor offers, with descriptions.
  static const List<(String, String)> placeholders = [
    ('contact_name', 'Contact person full name'),
    ('first_name', 'Contact first name'),
    ('business', 'Lead / client business name'),
    ('service', 'Service they are interested in'),
    ('potential_value', 'Potential value, formatted'),
    ('proposal_link', 'Proposal link saved on the lead'),
    ('meeting_date', 'Meeting date (when scheduling)'),
    ('meeting_time', 'Meeting time (when scheduling)'),
    ('meet_link', 'Google Meet link (when created)'),
    ('project_name', 'Project name (project emails)'),
    ('invoice_id', 'Invoice number (invoice emails)'),
    ('invoice_amount', 'Invoice amount (invoice emails)'),
    ('invoice_balance', 'Outstanding balance (invoice emails)'),
    ('invoice_due', 'Invoice due date (invoice emails)'),
    ('my_name', 'Your name (Settings → Profile)'),
    ('my_business', 'Your studio / business name'),
    ('my_phone', 'Your phone'),
    ('my_email', 'Your email'),
    ('my_website', 'Your website'),
    ('my_instagram', 'Your Instagram handle'),
    ('signature', 'Your signature block'),
  ];

  static Map<String, String> baseVars(AppSettingsState s) => {
        'my_name': s.myName,
        'my_business': s.businessName,
        'my_phone': s.myPhone,
        'my_email': s.myEmail.isNotEmpty ? s.myEmail : s.googleEmail,
        'my_website': s.myWebsite,
        'my_instagram': s.myInstagram,
        'signature': s.signature.isNotEmpty ? s.signature : _defaultSignature(s),
      };

  static String _defaultSignature(AppSettingsState s) {
    final lines = <String>[
      if (s.myName.isNotEmpty) s.myName,
      if (s.businessName.isNotEmpty) s.businessName,
      if (s.myPhone.isNotEmpty) s.myPhone,
      if (s.myWebsite.isNotEmpty) s.myWebsite,
      if (s.myInstagram.isNotEmpty) s.myInstagram,
    ];
    return lines.join('\n');
  }

  static Map<String, String> leadVars(Lead lead, AppSettingsState s, {FollowUp? meeting}) {
    final name = lead.contactPerson.trim();
    return {
      ...baseVars(s),
      'contact_name': name.isEmpty ? 'there' : name,
      'first_name': name.isEmpty ? 'there' : name.split(RegExp(r'\s+')).first,
      'business': lead.business,
      'service': lead.service.label,
      'potential_value': lead.potentialValue > 0 ? Fmt.money(lead.potentialValue) : '',
      'proposal_link': lead.proposalLink,
      'meeting_date': meeting != null ? Fmt.weekday(meeting.dueAt) : '',
      'meeting_time': meeting != null && meeting.hasTime ? Fmt.time(meeting.dueAt) : '',
      'meet_link': meeting?.meetLink ?? '',
    };
  }

  static Map<String, String> clientVars(Client c, AppSettingsState s, {Project? project, Invoice? invoice}) {
    final name = c.contactPerson.trim();
    return {
      ...baseVars(s),
      'contact_name': name.isEmpty ? 'there' : name,
      'first_name': name.isEmpty ? 'there' : name.split(RegExp(r'\s+')).first,
      'business': c.name,
      'service': (project?.service ?? c.service).label,
      'potential_value': '',
      'proposal_link': '',
      'meeting_date': '',
      'meeting_time': '',
      'meet_link': '',
      'project_name': project?.name ?? '',
      'invoice_id': invoice?.id ?? '',
      'invoice_amount': invoice != null ? Fmt.money(invoice.amount) : '',
      'invoice_balance': invoice != null ? Fmt.money(invoice.amount - invoice.amountReceived) : '',
      'invoice_due': invoice != null ? Fmt.date(invoice.dueDate) : '',
    };
  }
}

/// Produces a clean, responsive HTML email from plain text.
class EmailHtml {
  EmailHtml._();

  static String escape(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  static final RegExp _url = RegExp(r'(https?://[^\s<]+)');

  /// Converts paragraphs (blank-line separated) to `<p>`, single newlines to
  /// `<br>`, auto-links URLs and wraps everything in a branded shell.
  static String wrap({
    required String bodyText,
    required String brand,
    String accentHex = '#0d6efd',
    String? footer,
  }) {
    final paragraphs = bodyText.trim().split(RegExp(r'\n\s*\n'));
    final html = paragraphs.map((p) {
      var e = escape(p.trim());
      e = e.replaceAllMapped(_url, (m) => '<a href="${m.group(1)}" style="color:$accentHex;text-decoration:none;">${m.group(1)}</a>');
      e = e.replaceAll('\n', '<br>');
      return '<p style="margin:0 0 14px 0;">$e</p>';
    }).join('\n');

    final brandE = escape(brand);
    final footerE = escape(footer ?? 'Sent with FrameWorkz');

    return '''<!doctype html>
<html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>$brandE</title></head>
<body style="margin:0;padding:0;background:#f4f6f9;">
<table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background:#f4f6f9;padding:28px 12px;">
<tr><td align="center">
<table role="presentation" width="600" cellspacing="0" cellpadding="0" style="max-width:600px;width:100%;background:#ffffff;border-radius:14px;overflow:hidden;border:1px solid #e9ecef;font-family:Inter,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;">
<tr><td style="background:$accentHex;height:6px;font-size:0;line-height:0;">&nbsp;</td></tr>
<tr><td style="padding:26px 32px 6px 32px;">
<div style="font-size:13px;letter-spacing:.08em;text-transform:uppercase;color:#6c757d;font-weight:600;">$brandE</div>
</td></tr>
<tr><td style="padding:10px 32px 28px 32px;font-size:15px;line-height:1.6;color:#212529;">
$html
</td></tr>
<tr><td style="padding:16px 32px;background:#f8f9fa;border-top:1px solid #e9ecef;font-size:12px;color:#6c757d;">$footerE</td></tr>
</table>
</td></tr></table>
</body></html>''';
  }
}

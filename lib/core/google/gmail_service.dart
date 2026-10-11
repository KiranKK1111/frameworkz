import 'dart:convert';

import 'package:googleapis/gmail/v1.dart' as gmail;

import 'google_auth_service.dart';

/// Sends email through the connected Gmail account.
class GmailService {
  GmailService(this.auth);
  final GoogleAuthService auth;

  bool get available => auth.isConnected;

  /// Sends a multipart/alternative (text + HTML) message. Returns the Gmail
  /// message id.
  Future<String> send({
    required String to,
    required String subject,
    required String textBody,
    required String htmlBody,
    String? fromName,
    String? fromEmail,
    String? cc,
    String? bcc,
  }) async {
    await auth.ensureFresh();
    final api = auth.gmailApi;
    final raw = buildRawMessage(
      to: to,
      subject: subject,
      textBody: textBody,
      htmlBody: htmlBody,
      fromName: fromName,
      fromEmail: fromEmail ?? auth.state.value.email,
      cc: cc,
      bcc: bcc,
    );
    final msg = gmail.Message()..raw = raw;
    final sent = await api.users.messages.send(msg, 'me');
    return sent.id ?? '';
  }

  /// Builds an RFC 2822 message encoded as base64url (Gmail `raw`).
  static String buildRawMessage({
    required String to,
    required String subject,
    required String textBody,
    required String htmlBody,
    String? fromName,
    String? fromEmail,
    String? cc,
    String? bcc,
  }) {
    final boundary = 'bz_${DateTime.now().microsecondsSinceEpoch}';
    final sb = StringBuffer();
    if (fromEmail != null && fromEmail.isNotEmpty) {
      final name = (fromName ?? '').trim();
      sb.writeln(name.isEmpty ? 'From: $fromEmail' : 'From: ${_encodeWord(name)} <$fromEmail>');
    }
    sb.writeln('To: $to');
    if (cc != null && cc.trim().isNotEmpty) sb.writeln('Cc: ${cc.trim()}');
    if (bcc != null && bcc.trim().isNotEmpty) sb.writeln('Bcc: ${bcc.trim()}');
    sb.writeln('Subject: ${_encodeWord(subject)}');
    sb.writeln('MIME-Version: 1.0');
    sb.writeln('X-Mailer: FrameWorkz');
    sb.writeln('Content-Type: multipart/alternative; boundary="$boundary"');
    sb.writeln();
    sb.writeln('--$boundary');
    sb.writeln('Content-Type: text/plain; charset="UTF-8"');
    sb.writeln('Content-Transfer-Encoding: base64');
    sb.writeln();
    sb.writeln(_wrap76(base64.encode(utf8.encode(textBody))));
    sb.writeln('--$boundary');
    sb.writeln('Content-Type: text/html; charset="UTF-8"');
    sb.writeln('Content-Transfer-Encoding: base64');
    sb.writeln();
    sb.writeln(_wrap76(base64.encode(utf8.encode(htmlBody))));
    sb.writeln('--$boundary--');
    final bytes = utf8.encode(sb.toString().replaceAll('\n', '\r\n'));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static String _encodeWord(String s) {
    final ascii = RegExp(r'^[\x20-\x7E]*$');
    if (ascii.hasMatch(s)) return s;
    return '=?UTF-8?B?${base64.encode(utf8.encode(s))}?=';
  }

  static String _wrap76(String s) {
    final sb = StringBuffer();
    for (var i = 0; i < s.length; i += 76) {
      sb.writeln(s.substring(i, i + 76 > s.length ? s.length : i + 76));
    }
    return sb.toString().trimRight();
  }
}

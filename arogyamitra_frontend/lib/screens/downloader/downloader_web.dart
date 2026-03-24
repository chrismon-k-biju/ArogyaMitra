import 'dart:html' as html;

void downloadDocument(String content, String fileName) {
  final blob = html.Blob([content], 'text/plain', 'native');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}

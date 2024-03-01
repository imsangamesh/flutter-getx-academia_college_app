import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// Synchfusion by document  ===========================================
class OfflinePdfViewer extends StatelessWidget {
  const OfflinePdfViewer(this.doc, this.title, {Key? key}) : super(key: key);

  final File doc;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.file(doc, pageLayoutMode: PdfPageLayoutMode.single),
    );
  }
}

// Synchfusion by network  ===========================================
class OnlinePDFViewer extends StatelessWidget {
  const OnlinePDFViewer(this.url, this.title, {Key? key}) : super(key: key);

  final String url, title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.network(url),
    );
  }
}

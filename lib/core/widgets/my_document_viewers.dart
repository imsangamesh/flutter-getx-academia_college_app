import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// Synchfusion by document  ===========================================
class MyPdfViewer extends StatelessWidget {
  const MyPdfViewer(this.doc, this.title, {Key? key}) : super(key: key);

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
class MyNetPDFViewer extends StatelessWidget {
  const MyNetPDFViewer(this.url, this.title, {Key? key}) : super(key: key);

  final String url, title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.network(url),
    );
  }
}

//  small network image  ========================================
// class MyNetImageViewer extends StatelessWidget {
//   const MyNetImageViewer(
//     this.imageUrl, {
//     this.size,
//     Key? key,
//   }) : super(key: key);

//   final String imageUrl;
//   final double? size;

//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: imageUrl,
//       child: GestureDetector(
//         onTap: () =>
//             MyFullScreenNetImageViewer.showImagePopUp(context, imageUrl),
//         child: Container(
//           width: size ?? 150,
//           height: size ?? 150,
//           margin: const EdgeInsets.only(right: 10, bottom: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.network(imageUrl, fit: BoxFit.cover),
//           ),
//         ),
//       ),
//     );
//   }
// }

// //  full screen network image  ========================================
// class MyFullScreenNetImageViewer extends StatelessWidget {
//   const MyFullScreenNetImageViewer(this.url, {Key? key}) : super(key: key);

//   final String url;

//   static showImagePopUp(BuildContext context, String url) {
//     Get.dialog(
//       Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => Get.back(),
//               ),
//               Expanded(
//                 child: Hero(
//                   tag: url,
//                   child: InteractiveViewer(
//                     clipBehavior: Clip.none,
//                     minScale: 1,
//                     maxScale: 3,
//                     child: Image.network(url, fit: BoxFit.contain),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       barrierColor: Colors.black87,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox();
//   }
// }

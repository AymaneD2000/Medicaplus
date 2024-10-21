import 'dart:async';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFAssetScreen extends StatefulWidget {
  final String? path;
  String? name;
  PDFAssetScreen({Key? key, this.path, this.name}) : super(key: key);

  @override
  _PDFAssetScreenState createState() => _PDFAssetScreenState();
}

class _PDFAssetScreenState extends State<PDFAssetScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffc6e6ff),
        title: Text("Prescription"),
      ),
      body: Stack(
        children: <Widget>[
          SfPdfViewer.asset(widget.path!),
          errorMessage.isEmpty
              ? isReady
                  ? const Center(
                      child: CircularProgressIndicator(color: const Color(0xfffc6e6ff),),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}

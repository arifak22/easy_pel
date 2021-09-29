import 'dart:async';
import 'dart:io';

import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


class PdfViewScreen extends StatefulWidget {
  String uri;
  PdfViewScreen({required this.uri});
  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState(uri);
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  _PdfViewScreenState(String uri);
  String pathPDF = "";
  // String landscapePathPdf = "";
  String remotePDFpath = "";
  // String corruptedPathPDF = "";

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl(widget.uri).then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  Future<File> createFileOfPdfUrl(url) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception(e);
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF View',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                TextButton(
                  child: Text("Open PDF"),
                  onPressed: () {
                    if (pathPDF.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(path: pathPDF),
                        ),
                      );
                    }
                  },
                ),
                // TextButton(
                //   child: Text("Open Landscape PDF"),
                //   onPressed: () {
                //     if (landscapePathPdf.isNotEmpty) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               PDFScreen(path: landscapePathPdf),
                //         ),
                //       );
                //     }
                //   },
                // ),
                TextButton(
                  child: Text("Remote PDF"),
                  onPressed: () {
                    if (remotePDFpath.isNotEmpty) {
                      print(remotePDFpath);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(path: remotePDFpath),
                        ),
                      );
                    }
                  },
                ),
                // TextButton(
                //   child: Text("Open Corrupted PDF"),
                //   onPressed: () {
                //     if (pathPDF.isNotEmpty) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               PDFScreen(path: corruptedPathPDF),
                //         ),
                //       );
                //     }
                //   },
                // )
              ],
            );
          },
        )),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Detil Ketidakhadiran'),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
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
            return Container(
              margin: EdgeInsets.only(left: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 1,
                    label: Text("Previous"),
                    onPressed: () async {
                      await snapshot.data!.setPage(currentPage! - 1);
                    },
                  ),
                  FloatingActionButton.extended(
                    heroTag: 2,
                    label: Text((currentPage! + 1).toString() + " / " + (pages).toString()),
                    onPressed: () async {
                      // await snapshot.data!.setPage(pages! ~/ 2);
                    },
                  ),
                  FloatingActionButton.extended(
                    heroTag: 3,
                    label: Text("Next"),
                    onPressed: () async {
                      await snapshot.data!.setPage(currentPage! + 1);
                    },
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
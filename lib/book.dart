import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:page_turn/page_turn.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';

class Book extends StatefulWidget {
  final String pdf;

  Book({Key key, @required this.pdf}) : super(key: key);

  @override
  _BookState createState() => _BookState();
}

// String url = "http://192.168.30.102:8000/pdf/Agama/1.pdf";
String url = "http://dlibrary.manganoid.com/pdf/";
PDFDocument document;

class _BookState extends State<Book> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(url + widget.pdf.toString() + ".pdf");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _controller = GlobalKey<PageTurnState>();
    return Scaffold(
      body: PageTurn(
        key: _controller,
        backgroundColor: Colors.white,
        showDragCutoff: false,
        lastPage: Container(child: Center(child: Text('Load'))),
        children: _isLoading
            ? <Widget>[Center(child: Text("Preparing data, wait for 40s"))]
            : <Widget>[
                for (var i = 1; i < 25 /*document.count*/; i++)
                  AlicePage(
                    page: i,
                    pdf: widget.pdf.toString(),
                  ),
              ],
      ),
    );
  }
}

class AlicePage extends StatefulWidget {
  final int page;
  final String pdf;

  AlicePage({Key key, @required this.page, this.pdf}) : super(key: key);
  @override
  _AlicePageState createState() => _AlicePageState();
}

class _AlicePageState extends State<AlicePage> {
  PDFPage docPage;
  bool loading = true;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
    loadPage();
  }

  loadPage() async {
    document = await PDFDocument.fromURL(url + widget.pdf.toString() + ".pdf");
    docPage = await document.get(page: widget.page.toInt());
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomableWidget(
        child: DefaultTextStyle.merge(
      style: TextStyle(fontSize: 16.0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Text(
              //   "CHAPTER " + widget.page.toString(),
              //   style: TextStyle(
              //     fontSize: 32.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              Container(
                height: 650,
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : docPage,
              )
            ],
          ),
        ),
      ),
    ));
  }
}

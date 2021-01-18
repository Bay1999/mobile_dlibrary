import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookNormal extends StatefulWidget {
  final String pdf;
  final String buku_id;

  BookNormal({Key key, @required this.pdf, @required this.buku_id})
      : super(key: key);

  @override
  _BookNormalState createState() => _BookNormalState();
}

class _BookNormalState extends State<BookNormal> {
  bool _isLoading = true;
  String url = "http://dlibrary.manganoid.com/pdf/";
  PDFDocument document;

  Future<String> sendReader(var buku_id) async {
    final response = await http.post(
      'http://dlibrary.manganoid.com/api/addreader',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'buku_id': buku_id,
      }),
    );

    if (response.statusCode == 201) {
      print('berhasil nambah reader');
    } else {
      print('gagal connect' + response.statusCode.toString());
    }
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    super.initState();
    secureScreen();

    print("Buku_id " + widget.buku_id);
    sendReader(widget.buku_id);
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
    return Scaffold(
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document)),
    );
  }
}

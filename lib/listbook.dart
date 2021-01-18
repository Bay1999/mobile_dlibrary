import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dlibrary/model.dart';
import 'package:dlibrary/main.dart';
import 'package:dlibrary/detailbook.dart';

class Listbook extends StatefulWidget {
  final int id;
  final String kategori;

  Listbook({Key key, @required this.id, this.kategori}) : super(key: key);
  @override
  _ListbookState createState() => _ListbookState();
}

class _ListbookState extends State<Listbook> {
  // var url = 'http://192.168.30.102:8000/';
  var url = 'http://dlibrary.manganoid.com/';

  Future<List<Buku>> getList() async {
    // final response = await http
    //     .get('http://192.168.30.102:8000/api/listbuku/' + widget.id.toString());
    final response = await http.get(
        'http://dlibrary.manganoid.com/api/listbuku/' + widget.id.toString());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Buku.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load Kategori');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 254, 248, 85),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color.fromARGB(180, 0, 0, 0),
            tooltip: "Return to main menu",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AfterSplash()));
            },
          ),
          title: Text(
            widget.kategori,
            style: TextStyle(color: Color.fromARGB(180, 0, 0, 0), fontSize: 20),
          ),
        ),
        body: Container(
          // height: 1000,
          margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
          child: FutureBuilder<List<Buku>>(
              future: getList(),
              builder: (context, buku) {
                if (buku.hasData) {
                  return ListView.separated(
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Detailbook(
                                        id: buku.data[i].id,
                                        judul: buku.data[i].nama,
                                        penulis: buku.data[i].penulis,
                                        desc: buku.data[i].deskripsi,
                                        cover: buku.data[i].cover,
                                        bab: json.decode(buku.data[i].bab),
                                        pdf: json.decode(buku.data[i].pdf),
                                      )),
                            );
                          },
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ListTile(
                              title: Text(buku.data[i].nama,
                                  style: TextStyle(fontSize: 14)),
                              subtitle: Text(
                                buku.data[i].deskripsi,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12),
                              ),
                              leading: Image.network(
                                url + buku.data[i].cover,
                              ),
                              contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        );
                      },
                      itemCount: buku.data.length);
                } else if (buku.hasError) {
                  return Text("${buku.error}");
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }
}

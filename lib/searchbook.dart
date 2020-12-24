import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dlibrary/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dlibrary/detailbook.dart';

class Searchbook extends StatefulWidget {
  @override
  _SearchbookState createState() => _SearchbookState();
}

class _SearchbookState extends State<Searchbook> {
  // var url = 'http://192.168.30.102:8000/';
  var url = 'http://dlibrary.manganoid.com/';
  var search;
  final searchController = new TextEditingController();

  Future<List<Buku>> getList(search) async {
    final response =
        await http.get('http://dlibrary.manganoid.com/api/search/' + search);
    // final response =
    //     await http.get('http://192.168.30.102:8000/api/search/' + search);
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
        body: Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color.fromARGB(255, 254, 248, 85)),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              controller: searchController,
              style: TextStyle(fontSize: 16),
              onChanged: (search) {
                setState(() {
                  getList(searchController.text);
                });
              },

              // keyboardType: search,
              autofocus: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Cari Buku',
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                  suffixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none),
            ),
          ),
          Container(
            height: 650,
            margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
            child: FutureBuilder<List<Buku>>(
                future: getList(searchController.text),
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
                                          desc: buku.data[i].deskripsi,
                                          cover: buku.data[i].cover,
                                          bab: json.decode(buku.data[i].bab),
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(5, 0, 5, 10),
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
                  } else if (!buku.hasData) {
                    return Text("Not Found");
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          )
        ],
      )
    ]));
  }
}

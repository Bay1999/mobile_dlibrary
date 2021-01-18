import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'package:dlibrary/listbook.dart';
import 'package:dlibrary/model.dart';
import 'package:dlibrary/searchbook.dart';
import 'package:dlibrary/detailbook.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var search;
  // var url = 'http://192.168.56.1:8000/';
  // var url = 'http://192.168.30.102:8000/';
  var url = 'http://dlibrary.manganoid.com/';

  Future<List<Kategori>> getKategori() async {
    final response =
        await http.get('http://dlibrary.manganoid.com/api/kategori');
    // final response = await http.get('http://192.168.30.102:8000/api/kategori');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Kategori.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load Kategori');
    }
  }

  Future<List<Buku>> getBuku() async {
    final response = await http.get('http://dlibrary.manganoid.com/api/buku');
    // final response = await http.get('http://192.168.30.102:8000/api/buku');
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
      // appBar: AppBar(
      //   bottom: ,
      // ),

      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(color: Color.fromARGB(255, 254, 248, 85)),
              ),
              Flexible(
                flex: 4,
                child: Container(color: Colors.white),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //tulisan library
              Container(
                // margin: EdgeInsets.fromLTRB(40, 30, 40, 20),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15,
                    vertical: MediaQuery.of(context).size.height * 0.02),
                child: Text(
                  "D-Library",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(180, 0, 0, 0),
                      decoration: TextDecoration.none),
                ),
              ),

              //form pencarian
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32)),
                      child: TextFormField(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Searchbook(),
                              ));
                        },
                        autofocus: false,
                        keyboardType: search,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 13, 20, 10),
                            hintText: 'Search Book',
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 16),
                            suffixIcon: Icon(Icons.search),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),

              //tulisan Category
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.height * 0.03,
                    MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.height * 0.01),
                child: Text(
                  "Kategori",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(180, 0, 0, 0),
                      decoration: TextDecoration.none),
                ),
              ),

              //List Kategori
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                child: FutureBuilder<List<Kategori>>(
                    future: getKategori(),
                    builder: (context, kategori) {
                      if (kategori.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              width: 140,
                              // margin: EdgeInsets.fromLTRB(5, 5, 5, 25),
                              margin: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.02,
                                  MediaQuery.of(context).size.height * 0.01,
                                  MediaQuery.of(context).size.width * 0.02,
                                  MediaQuery.of(context).size.height * 0.03),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.white,
                                  elevation: 10,
                                  shadowColor: Color.fromARGB(150, 0, 0, 0),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Listbook(
                                                    id: kategori.data[i].id,
                                                    kategori: "Category " +
                                                        kategori.data[i].nama,
                                                  )),
                                        );
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsetsDirectional.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03),
                                            child: Image.network(
                                              url + kategori.data[i].img,
                                              // fit: BoxFit.cover,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.09,

                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.16,
                                            ),
                                          ),
                                          Container(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: ListTile(
                                                title: Text(
                                                  kategori.data[i].nama,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ))),
                            );
                          },
                          itemCount: kategori.data.length,
                        );
                      } else if (kategori.hasError) {
                        // return Text("${kategori.error}");
                        return Center(
                          child: new FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                getKategori();
                                CircularProgressIndicator();
                              });
                            },
                            child: new Icon(Icons.refresh),
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),

              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(35, 5, 40, 15),
                    // color: Colors.blue,
                    child: Text(
                      "Daftar Buku",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(180, 0, 0, 0),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.1, 5, 0, 15),
                    // color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Listbook(
                                      id: 0,
                                      kategori: "All Book",
                                    )),
                          );
                        },
                        child: Text(
                          "Semua Buku>",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(180, 0, 0, 0),
                              decoration: TextDecoration.none),
                        )),
                  ),
                ],
              ),

              //List Buku
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
                child: FutureBuilder<List<Buku>>(
                    future: getBuku(),
                    builder: (context, buku) {
                      if (buku.hasData) {
                        return ListView.separated(
                            itemBuilder: (BuildContext context, int i) {
                              // List<String> bab = buku.data[i].bab.to;
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
                                                bab: json
                                                    .decode(buku.data[i].bab),
                                                pdf: json
                                                    .decode(buku.data[i].pdf),
                                              )));
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
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    trailing: Image.network(
                                      url + buku.data[i].cover,
                                      // fit: BoxFit.cover,
                                      scale: 1,
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
                            itemCount: 6);
                      } else if (buku.hasError) {
                        return Text("${buku.error}");
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

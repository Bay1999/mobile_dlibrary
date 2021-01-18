import 'package:dlibrary/detailbook.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dlibrary/sharedpref.dart';
import 'package:dlibrary/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Bookmark extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  List<String> bookmark = [];
  var url = 'http://dlibrary.manganoid.com/';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MySharedPreferences.instance.getBookmark("bm").then((value) => setState(() {
          bookmark = value;
        }));
    print(bookmark);
  }

  Future<List<Buku>> getBookmark(idBook) async {
    print('idBook = ' + idBook);
    final response = await http
        .get('http://dlibrary.manganoid.com/api/listbookmark/' + idBook);
    // final response =
    //     await http.get('http://192.168.30.102:8000/api/search/' + search);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(response.statusCode);
      return jsonResponse.map((job) => new Buku.fromJson(job)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load Kategori');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 254, 248, 85),
        automaticallyImplyLeading: false,
        title: Text(
          "Bookmark",
          style: TextStyle(
              color: Color.fromARGB(150, 0, 0, 0), fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // getBookmark(bookmark[index]);
            return FutureBuilder<List<Buku>>(
                future: getBookmark(bookmark[index]),
                builder: (context, buku) {
                  if (buku.hasData) {
                    return ListTile(
                        title: Text(buku.data[0].nama,
                            style: TextStyle(fontSize: 14)),
                        subtitle: Text(
                          buku.data[0].deskripsi,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
                        ),
                        leading: Image.network(
                          url + buku.data[0].cover,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detailbook(
                                      id: buku.data[0].id,
                                      judul: buku.data[0].nama,
                                      desc: buku.data[0].deskripsi,
                                      cover: buku.data[0].cover,
                                      bab: json.decode(buku.data[0].bab),
                                      penulis: buku.data[0].penulis,
                                    )),
                          );
                        });
                  } else if (buku.hasError) {
                    return Text("${buku.error}");
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          },
          itemCount: bookmark.length,
        ),
        //     Column(
        //   children: <Widget>[
        //     Text("Ini Halaman Bookmarks" + bookmark[1].toString()),
        //     // ListView.builder(
        //     //   itemBuilder: (context, index) {
        //     //     return Padding(
        //     //       padding: const EdgeInsets.all(8.0),
        //     //       child: Text(bookmark[index]),
        //     //     );
        //     //   },
        //     //   itemCount: bookmark.length,
        //     // ),
        //   ],
        // )
      ),
    );
  }
}

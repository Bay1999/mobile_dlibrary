import 'package:dlibrary/model.dart';
import 'package:dlibrary/sharedpref.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:dlibrary/book.dart';
import 'package:dlibrary/booknormal.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Detailbook extends StatefulWidget {
  final int id;
  final String judul;
  final String desc;
  final String cover;
  final List<dynamic> bab;
  final List<dynamic> pdf;

  Detailbook({
    Key key,
    @required this.id,
    this.judul,
    this.desc,
    this.cover,
    this.bab,
    this.pdf,
  }) : super(key: key);
  @override
  _DetailbookState createState() => _DetailbookState();
}

class _DetailbookState extends State<Detailbook> {
  // var url = 'http://192.168.30.102:8000/';
  var url = 'http://dlibrary.manganoid.com/';
  bool bookmarkAdd = false;
  bool user = false;
  String pageTurn = 'true', username;

  //comment variable
  final commentController = TextEditingController();
  var rate, reader;
  String comment;

  Review review = null;
  var allReview = null;

  Future<List<Review>> sendReview(
      int idBuku, String user, String comment, String rate) async {
    final response = await http.post(
      'http://dlibrary.manganoid.com/api/addreview',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idBuku': idBuku,
        'user': user,
        'comment': comment,
        'rate': rate,
      }),
    );

    if (response.statusCode == 201) {
      print('berhasil connect');
    } else {
      print('gagal connect' + response.statusCode.toString());
    }
  }

  //all review
  Future<Review> getReview(int idBuku, String user) async {
    final response = await http.post(
      'http://dlibrary.manganoid.com/api/review',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'buku_id': idBuku,
        'user': user,
      }),
    );
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      return Review.fromJson(jsonObject);
    } else {
      print('gagal get ' + response.statusCode.toString());
      // throw Exception('Failed to load Kategori');
    }
  }

  Future<AllReview> getAllReview() async {
    final response = await http.get(
        'http://dlibrary.manganoid.com/api/allreview/' + widget.id.toString());
    // final response = await http.get('http://192.168.30.102:8000/api/buku');
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // print('code 200');
      return AllReview.fromJson(jsonResponse);
    } else {
      print('statusCode ' + response.statusCode.toString());
      throw Exception('Failed to load Kategori');
    }
  }

  void _boolPageTurn() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      if (myPrefs.getString('pageTurn') != null) {
        pageTurn = myPrefs.getString('pageTurn');
      }
    });
  }

  void _cekBookmark() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    List<String> bookmark = myPrefs.getStringList('bm');
    for (var i = 0; i < bookmark.length; i++) {
      if (bookmark[i] == widget.id.toString()) {
        setState(() {
          bookmarkAdd = true;
        });
        break;
      }
    }
  }

  _cekUsername() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (myPrefs.getString('username') != null) {
      user = true;
      getReview(widget.id, myPrefs.getString('username')).then((value) {
        setState(() {
          username = myPrefs.getString('username');
          print(username);
          review = value;
          print("rate = " + review.rate.toString());
          if (review != null) {
            rate = review.rate;
            commentController.text = review.commentar;
            print(rate);
          } else {
            rate = 0.0;
            print(rate);

            commentController.text = null;
          }
        });
      });
    } else {
      user = false;
    }
  }

  Future<String> getReader() async {
    // final response = await http
    //     .get('http://192.168.30.102:8000/api/listbuku/' + widget.id.toString());
    final response = await http.get(
        'http://dlibrary.manganoid.com/api/getreader/' + widget.id.toString());
    if (response.statusCode == 200) {
      // reader = json.decode(response.body).toString();
      // print('sukses');
      // print('jumlah reader ' + reader);
      return json.decode(response.body).toString();
    } else {
      print('eror ' + response.statusCode.toString());
      throw Exception('Failed to load Kategori');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getReview(widget.id, username);
    // });
    getReader().then((value) {
      print(value);
      setState(() {
        reader = value;
      });
    });
    _cekBookmark();
    _boolPageTurn();
    _cekUsername();
    // print('ini adalah : ' + reader);
    // _review();

    // getAllReview();
  }

  @override
  Widget build(BuildContext context) {
    if (reader == null) {
      setState(() {});
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // toolbarHeight: 80,
            floating: false,
            pinned: true,
            snap: false,
            expandedHeight: 500.0,
            backgroundColor: Colors.blueAccent,
            actions: <Widget>[
              if (bookmarkAdd)
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      MySharedPreferences.instance
                          .removeBookmark(widget.id.toString());
                      bookmarkAdd = false;
                    });
                  },
                )
              else
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      MySharedPreferences.instance
                          .setBookmark(widget.id.toString());
                      bookmarkAdd = true;
                    });
                  },
                )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'http://dlibrary.manganoid.com/' + widget.cover.toString(),
                // 'http://192.168.30.102:8000/' + widget.cover.toString(),
                fit: BoxFit.cover,
                color: Color.fromARGB(100, 0, 0, 0),
                colorBlendMode: BlendMode.srcATop,
              ),
              title: Text(
                widget.judul.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              titlePadding: EdgeInsets.fromLTRB(50, 5, 10, 18),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25))
                      // borderRadius: BorderRadius.circular(32)
                      ),
                  // padding: EdgeInsets.all(40),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
                        child: Text(
                          "Pembaca : " + reader.toString(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
                        child: Text(
                          widget.desc.toString(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(
                        height: 400,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                        color: Color.fromARGB(255, 245, 245, 245),
                        child: SingleChildScrollView(
                          // color: Color.fromARGB(255, 245, 245, 245),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // for (var i in widget.bab)
                              for (var i = 0; i < widget.bab.length; i++)
                                // for (var i = 0; i < widget.bab.toString(); i++)
                                // Text(i)
                                Container(
                                  // width: 180,
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      color: Colors.white,
                                      elevation: 8,
                                      shadowColor: Color.fromARGB(150, 0, 0, 0),
                                      child: InkWell(
                                          onTap: () {},
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            25, 10, 10, 10),
                                                    title: Text(
                                                      "Bab : " +
                                                          widget.bab[i]
                                                              .toString(),
                                                      // overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    trailing: Icon(Icons
                                                        .arrow_forward_ios),
                                                    onTap: () {
                                                      if (pageTurn == "true")
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Book(
                                                                pdf: widget
                                                                    .pdf[i]
                                                                    .toString(),
                                                              ),
                                                            ));
                                                      else
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      BookNormal(
                                                                pdf: widget
                                                                    .pdf[i]
                                                                    .toString(),
                                                                buku_id: widget
                                                                    .id
                                                                    .toString(),
                                                              ),
                                                            ));
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (!user)
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: Center(
                            child: Text(
                                'Masukan username pada pengaturan untuk dapat memberikan rating dan ulasan pada buku',
                                textAlign: TextAlign.center),
                          ),
                        ),
                      if (user)
                        Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              // color: Colors.red,
                              margin: EdgeInsets.fromLTRB(40, 10, 40, 0),
                              child: Text("Beri rating buku ini",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              // color: Colors.red,
                              margin: EdgeInsets.fromLTRB(40, 5, 40, 10),
                              child: Text("Sampaikan pendapatmu",
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      if (user)
                        Container(
                          // color: Colors.red,
                          margin: EdgeInsets.fromLTRB(40, 10, 40, 30),
                          child: RatingBar(
                            glow: false,
                            initialRating: rate != null ? rate : 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 10.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.blueAccent,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                rate = rating;
                              });
                              print(rate);
                            },
                          ),
                        ),
                      if (user)
                        Container(
                          margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
                          child: TextFormField(
                            controller: commentController,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(fontSize: 14),
                            cursorColor: Colors.amber,
                            minLines: 1,
                            maxLines: 8,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'Deskripsikan pengalamanmu',
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 14),
                            ),
                            onChanged: (search) {
                              setState(() {
                                comment = commentController.text;
                              });
                            },
                          ),
                        ),
                      if (rate != null && rate >= 0)
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: FlatButton(
                            child: Text('Send'),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              print("User = " + username);
                              print("Id Buku = " + widget.id.toString());
                              print("Rate = " + rate.toString());
                              print("Comment = " + comment);
                              sendReview(widget.id, username, comment,
                                  rate.toString());
                              setState(() {});
                            },
                          ),
                        ),
                      FutureBuilder(
                          future: getAllReview(),
                          builder: (context, reviewAll) {
                            if (reviewAll.hasData) {
                              return Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.fromLTRB(40, 30, 40, 20),
                                      child: Text("Rating dan ulasan",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16))),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: Text(
                                              reviewAll.data.rating.toString(),
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32))),
                                      Container(
                                        // color: Colors.red,
                                        margin:
                                            EdgeInsets.fromLTRB(40, 5, 40, 30),
                                        child: RatingBar(
                                          ignoreGestures: true,
                                          glow: false,
                                          initialRating: reviewAll.data.rating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.blueAccent,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ),

                                      for (var i = 0;
                                          i < reviewAll.data.data.length;
                                          i++)
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      child: Icon(Icons
                                                          .account_circle)),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: Text(reviewAll
                                                        .data.data[i].user),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                margin: EdgeInsets.fromLTRB(
                                                    40, 10, 40, 20),
                                                child: Text(
                                                  reviewAll
                                                      .data.data[i].commentar,
                                                  textAlign: TextAlign.justify,
                                                ))
                                          ],
                                        )

                                      // Text(reviewAll.data.data.length
                                      //         .toString() +
                                      //     " ini panjang")
                                      // ListView.builder(
                                      //   itemBuilder: (context, i) {
                                      //     Text(
                                      //         reviewAll.data.data[i].commentar +
                                      //             "ini commentar");
                                      //   },
                                      //   itemCount: reviewAll.data.data.length,
                                      // ),
                                    ],
                                  ),
                                ],
                              );
                            } else if (reviewAll.hasError) {
                              // return Text("${kategori.error}");
                              print(reviewAll.error);
                              return Container(
                                margin: EdgeInsetsDirectional.only(bottom: 30),
                                child: Center(child: Text("Belum Ada Ulasan")),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ],
                  ))
            ]),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';

class Kategori {
  final int id;
  final String nama;
  final String img;

  Kategori({this.id, this.nama, this.img});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'],
      img: json['img'],
    );
  }
}

class Buku {
  final int id;
  final String kategori_id;
  final String nama;
  final String penulis;
  final String deskripsi;
  final String cover;
  final String bab;
  final String pdf;

  Buku({
    this.id,
    this.kategori_id,
    this.nama,
    this.penulis,
    this.deskripsi,
    this.cover,
    this.bab,
    this.pdf,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      kategori_id: json['kategori_id'],
      nama: json['nama'],
      penulis: json['penulis'],
      deskripsi: json['deskripsi'],
      cover: json['cover'],
      bab: json['bab'],
      pdf: json['pdf'],
      // bab: Bab.fromJson(Map < List, dynamic > json){

      // },
    );
  }
}

class Review {
  String idBuku;
  String user;
  String commentar;
  var rate;

  Review({this.idBuku, this.user, this.commentar, this.rate});

  factory Review.fromJson(Map<String, dynamic> object) {
    return Review(
      idBuku: object['buku_id'],
      user: object['user'],
      commentar: object['commentar'],
      rate: object['rate'] != null ? object['rate'].toDouble() : 1.0,
    );
  }
}

class AllReview {
  List<Review> data;
  double rating;

  AllReview({this.data, this.rating});

  factory AllReview.fromJson(Map<String, dynamic> json) {
    // List<Review> dataReview;

    // if (json['data'] != null) {
    //   json['data'].forEach((v) {
    //     dataReview.add(Review.fromJson(v));
    //   });
    // }
    var list = json['data'] as List;
    List<Review> reviewList = list.map((i) => Review.fromJson(i)).toList();
    return AllReview(data: reviewList, rating: json['rating'].toDouble());
  }
}

class Reader {
  var buku_id;

  Reader({this.buku_id});

  factory Reader.fromJson(Map<String, dynamic> object) {
    return Reader(
      buku_id: object['buku_id'],
    );
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  MySharedPreferences._privateConstructor();
  List<String> bookmark = [];

  static final MySharedPreferences instance =
      MySharedPreferences._privateConstructor();

  setBookmark(String idBook) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    print("add bookmark function");
    if (myPrefs.containsKey("bm")) {
      bookmark = myPrefs.getStringList("bm");
      bookmark.add(idBook);
      myPrefs.setStringList("bm", bookmark);
      print(myPrefs.getStringList("bm"));
    } else {
      myPrefs.setStringList("bm", bookmark);
      bookmark = myPrefs.getStringList("bm");
      bookmark.add(idBook);
      myPrefs.setStringList("bm", bookmark);
      print(idBook);
    }
  }

  Future<List<String>> getBookmark(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getStringList("bm") ?? "";
  }

  setPageTurn(String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString("pageTurn", value);
    print(myPrefs.getString("pageTurn"));
  }

  Future<String> getPageTurn() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('pageTurn') ?? "";
  }

  removeBookmark(String idBook) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    bookmark = myPrefs.getStringList('bm');
    print("remove bookmark function");

    for (var i = 0; i < bookmark.length; i++) {
      if (bookmark[i] == idBook) {
        bookmark.removeAt(i);
        break;
      }
    }
    myPrefs.setStringList("bm", bookmark);
    print(myPrefs.getStringList("bm"));
  }

  addUsername(String name) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString("username", name);
    print(myPrefs.getString("username"));
  }

  Future<String> getUsername() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString('username') ?? "";
  }
}

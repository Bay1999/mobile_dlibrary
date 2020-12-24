import 'package:dlibrary/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dlibrary/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

bool status = true;

class _SettingState extends State<Setting> {
  var name, username, pageTurn;
  final nameController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getShared();
    // setState(() {});
  }

  _getShared() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      username = myPrefs.getString('username');
      pageTurn = myPrefs.getString('pageTurn') == null
          ? status = true
          : myPrefs.getString('pageTurn') == 'false'
              ? status = false
              : status = true;
    });
    print(username);
    print(myPrefs.getString('pageTurn'));
    print(status);
  }

  _openPopup(context) {
    Alert(
        context: context,
        title: "LOGIN",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Username',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "LOGIN",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show().then((exit) {
      if (exit == null) return;

      if (exit) {
        print("exit");
      } else {
        print("exit no");
      }
    });
  }

  addUser(name) {
    MySharedPreferences.instance.addUsername(name);
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = username;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 254, 248, 85),
          automaticallyImplyLeading: false,
          title: Text(
            "Setting",
            style: TextStyle(
                color: Color.fromARGB(150, 0, 0, 0),
                fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 30),
                  child: Column(
                    children: <Widget>[
                      Text("Input your name for review features",
                          textAlign: TextAlign.left),
                      Container(
                        child: TextFormField(
                          controller: nameController,
                          autofocus: false,
                          keyboardType: name,
                          onFieldSubmitted: (name) {
                            setState(() {
                              MySharedPreferences.instance
                                  .addUsername(nameController.text.toString());
                              _getShared();
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                            hintText: 'Your Name',
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  )),
              Row(
                children: <Widget>[
                  Text("Active page turn effect"),
                  Container(
                    // alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.25, 0, 0, 0),
                    child: CustomSwitch(
                      activeColor: Colors.redAccent,
                      value: status,
                      onChanged: (value) {
                        print("VALUE : $value");
                        setState(() {
                          MySharedPreferences.instance.setPageTurn("$value");
                          status = value;
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

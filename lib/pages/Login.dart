import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techtatva19/main.dart';
import 'dart:convert';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:techtatva19/models/UserModel.dart';
import 'package:techtatva19/pages/RegisteredEvents.dart';
import 'package:url_launcher/url_launcher.dart';

UserData user;

Dio dio = new Dio();

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVerifying = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_cacheUserDetails();
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.teal.withOpacity(0.3), Colors.greenAccent],
  ).createShader(Rect.fromLTRB(0.0, 0.0, 400.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return !isLoggedIn ? _loginPage(context) : _userPage(context);
  }

  _loginPage(context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              //color: Colors.red,
              margin: EdgeInsets.only(top: height * 0.07),
              height: height * 0.17,
              width: 150.0,
              child: Image.asset("assets/logo_NEW_NEW.png"),
            ),
            Container(
              width: 1.0,
              height: height * 0.12,
              alignment: Alignment.center,
              child: Text(
                "Welcome.",
                style: TextStyle(
                    fontSize: 35.0,
                    foreground: Paint()..shader = linearGradient),
              ),
              //  color: Colors.red,
            ),
            Container(
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  alignment: Alignment.center,
                  height: height * 0.18,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "email address",
                            labelStyle: TextStyle(color: Colors.white54),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white54,
                            )),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'password',
                            labelStyle: TextStyle(color: Colors.white54),
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.white54)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 20.0,
              height: height * 0.04,
            ),
            Container(
              //color: Colors.red,
              height: height * 0.25,
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.1, 0.3, 0.7, 0.9],
                            colors: [
                              Colors.orangeAccent.withOpacity(0.9),
                              Colors.orangeAccent.withOpacity(0.7),
                              Colors.teal.withOpacity(0.8),
                              Colors.teal.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25.0)),
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: MaterialButton(
                        onPressed: () {
                          _loginRequest(
                              _emailController.text, _passwordController.text);
                        },
                        splashColor: Colors.greenAccent,
                        child: Container(
                          width: 300.0,
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: new Border.all(color: Colors.orangeAccent),
                          borderRadius: BorderRadius.circular(25.0)),
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: MaterialButton(
                        onPressed: () {
                          _launchURL("https://register.techtatva.in/");
                        },
                        splashColor: Colors.greenAccent,
                        child: Container(
                          width: 300.0,
                          alignment: Alignment.center,
                          child: Text(
                            "Register Now",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.red,
                    width: height * 0.085,
                    height: height * 0.085,
                    alignment: Alignment.center,
                    child: isVerifying ? CircularProgressIndicator() : null,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _userPage(context) {
    try {
      print(user.qrCode);
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(6.0),
          color: Colors.black,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  user.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w100),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                color: Colors.greenAccent,
                height: 0.5,
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildUserTile(context, "Delegate ID", user.id.toString()),
                    _buildUserTile(context, "Registration No.", user.regNo),
                    _buildUserTile(context, "College", user.collegeName),
                    _buildUserTile(context, "Phone", user.mobilNumber),
                    _buildUserTile(context, "Email ID", user.emailId),
                  ],
                ),
              ),
              Container(
                color: Colors.greenAccent,
                height: 0.5,
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(64, 18, 64, 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    color: Colors.white,
                    child: Center(
                      child: RepaintBoundary(
                        child: QrImage(
                          data: user.qrCode,
                          size: MediaQuery.of(context).size.height * 0.27,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(50.0, 10, 50.0, 6.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.1, 0.3, 0.7, 0.9],
                        colors: [
                          Colors.blue.withOpacity(0.9),
                          Colors.blue.withOpacity(0.9),
                          Colors.blueAccent.withOpacity(0.9),
                          Colors.blueAccent.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25.0)),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new RegisteredEvents();
                      }));
                    },
                    child: Container(
                      width: 300.0,
                      alignment: Alignment.center,
                      child: Text(
                        "Event Registration",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(50.0, 10, 50.0, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.1, 0.3, 0.7, 0.9],
                        colors: [
                          Colors.red.withOpacity(0.8),
                          Colors.red.withOpacity(0.8),
                          Colors.redAccent.withOpacity(1),
                          Colors.redAccent.withOpacity(1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25.0)),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      _logoutRequest();
                    },
                    child: Container(
                      width: 300.0,
                      alignment: Alignment.center,
                      child: Text(
                        "Logout",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            "There appears to be some error, don't panic. Just toggle between tabs or restart the app.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }
  }

  _getQRCode(context) async {
    preferences = await SharedPreferences.getInstance();
    String qr = preferences.getString('userQR');
    print(qr);
    String url =
        "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$qr";

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 170.0,
      width: 600,
      alignment: Alignment.center,
      child: Container(
          width: 170.0,
          height: 170.0,
          child: CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: url)),
    );
  }

  _logoutRequest() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var cookieJar = PersistCookieJar(
        dir: tempPath, ignoreExpires: true, persistSession: true);

    dio.interceptors.add(CookieManager(cookieJar));
    var resp = await dio.get("/logout");

    if (resp.statusCode == 200) {
      isLoggedIn = false;
      preferences = await SharedPreferences.getInstance();
      preferences.setBool('isLoggedIn', false);
      setState(() {});
    }
  }

  _buildUserTile(context, key, value) {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 6, 20, 6),
      height: 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(key,
              style: TextStyle(
                color: Colors.white70,
              )),
          Text(value,
              style: TextStyle(
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  _loginRequest(String email, String password) async {
    isVerifying = true;
    setState(() {});
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      String token = "kr4Ju4ImZ7aPJoQLhepb";
      String type = "invisible";

      var cookieJar = PersistCookieJar(
          dir: tempPath, ignoreExpires: true, persistSession: true);

      dio.interceptors.add(CookieManager(cookieJar));

      print("tap");

      var response = await dio.post("/login", data: {
        "email": email,
        "password": password,
        'g-recaptcha-response': token,
        'type': type
      });

      print(response.statusCode);
      print(response.data);

      if (response.statusCode == 200 && response.data['success'] == true) {
        print("object");
        preferences = await SharedPreferences.getInstance();
        preferences.setBool('isLoggedIn', true);
        var resp = await dio.get("/userProfile");
        isLoggedIn = true;

        user = UserData(
            id: resp.data['data']['id'],
            name: resp.data['data']['name'],
            regNo: resp.data['data']['regno'],
            mobilNumber: resp.data['data']['mobile'],
            emailId: resp.data['data']['email'],
            qrCode: resp.data['data']['qr'],
            collegeName: resp.data['data']['collname']);
        preferences.setString('userId', user.id.toString());
        preferences.setString('userName', user.name);
        preferences.setString('userReg', user.regNo.toString());
        preferences.setString('userMob', user.mobilNumber.toString());
        preferences.setString('userEmail', user.emailId);
        preferences.setString('userQR', user.qrCode);
        preferences.setString('userCollege', user.collegeName);
        preferences.setString('userPassword', password);
        isVerifying = false;
        setState(() {});
      } else if (response.statusCode == 200 &&
          response.data['msg'] == "Invalid email/password combination") {
        _passwordController.clear();
        _emailController.clear();
        isVerifying = false;
        setState(() {});
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Invalid email or password"),
              content: new Text(
                  "Please check the email or password you have entered"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 200 &&
          response.data['msg'] == "Invalid input") {
        _passwordController.clear();
        _emailController.clear();
        isVerifying = false;
        setState(() {});
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Invalid Input"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        _passwordController.clearComposing();
        _emailController.clear();
        isVerifying = false;
        setState(() {});
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                  "There seems to be some error. Please ensure you are connected to the internet and try again"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

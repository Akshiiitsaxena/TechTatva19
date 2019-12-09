import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:techtatva19/main.dart';
import 'package:techtatva19/pages/Categories.dart';
import 'package:techtatva19/pages/DelegateCards.dart';
import 'package:techtatva19/pages/LiveBlog.dart';
import 'package:techtatva19/pages/Login.dart';
import 'package:techtatva19/pages/Results.dart';
import 'package:techtatva19/pages/Schedule.dart';
import 'package:techtatva19/HomeImages.dart';
import 'package:techtatva19/pages/Sponsors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Developers.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    fromHome = false;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: ListView(
        children: <Widget>[
          Container(
            height: 200.0,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Container(
                        child: Image.asset("assets/ttlogo.png"),
                      ),
                    ),
                    fadeInDuration: Duration(milliseconds: 100),
                    fadeOutDuration: Duration(milliseconds: 100),
                    imageUrl: homeImages[Random.secure().nextInt(10)],
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(left: 24.0),
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.3, 0.7, 0.9],
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Container(
                      height: 50.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "TechTatva'19",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 24.0),
                          ),
                          Text(
                            "Embracing Contraries",
                            style: TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(55.0, 2.0, 55.0, 18.0),
            color: Colors.transparent,
            height: 0.5,
          ),
          _buildHeaderContainer(context, 'Categories', 'Curated just for you',
              FontAwesomeIcons.shapes, Colors.greenAccent),
          _buildHeaderContainer(context, 'Live Blog', 'Powered by MIT Post',
              FontAwesomeIcons.userClock, Colors.pinkAccent),
          _buildHeaderContainer(
              context,
              'Delegate Cards',
              'Various cards for different events',
              FontAwesomeIcons.creditCard,
              Colors.deepOrangeAccent),
          _buildHeaderContainer(context, 'Sponsors', 'Our Proud Partners',
              FontAwesomeIcons.handsHelping, Colors.blueAccent),
          _buildHeaderContainer(
              context,
              'Developers',
              'Made with Love by App Dev',
              FontAwesomeIcons.codeBranch,
              Colors.lightGreenAccent),
          Container(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.facebook,
                    color: Color.fromRGBO(59, 89, 152, 1),
                    size: 32.0,
                  ),
                  onPressed: () {
                    _launchURL("https://www.facebook.com/MITtechtatva/");
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.twitter,
                      color: Color.fromRGBO(29, 161, 242, 1), size: 32.0),
                  onPressed: () {
                    _launchURL("https://twitter.com/mittechtatva");
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.instagram,
                      color: Colors.pinkAccent, size: 32.0),
                  onPressed: () {
                    _launchURL("https://www.instagram.com/mittechtatva/");
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.youtube,
                      color: Color.fromRGBO(196, 48, 43, 1), size: 32.0),
                  onPressed: () {
                    _launchURL("https://www.youtube.com/user/TechTatva");
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
            color: Colors.greenAccent,
            height: 0.5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(24.0),
            child: Text(
              desc,
              style: TextStyle(color: Colors.white70, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(150, 20, 150, 30),
              alignment: Alignment.center,
              child: Image.asset("assets/logo_NEW_NEW.png")),
          Container(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Developed with  ",
                  style: TextStyle(color: Colors.white70),
                ),
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Color.fromRGBO(Random.secure().nextInt(255), Random.secure().nextInt(255), Random.secure().nextInt(255), 1),
                  size: 12.0,
                ),
                Text(
                  "  by the App Dev Team",
                  style: TextStyle(color: Colors.white70),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildHeaderContainer(context, title, desc, icon, color) {
    return InkWell(
      onTap: () {
        if (title == "Categories")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Categories();
          }));
        else if (title == "Delegate Cards")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return DelegateCard();
          }));
        else if (title == "Live Blog")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return LiveBlog();
          }));
        else if (title == "Developers")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Developers();
          }));
        else if (title == "Sponsors")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Sponsors();
          }));

        for (var event in allEvents) {
          print(event.visible);
          print(event.name);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
        //    color: Colors.blueAccent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 80.0,
              width: 80.0,
              child: CircleAvatar(
                backgroundColor: Colors.white12,
                child: Icon(
                  icon,
                  color: color,
                  size: 36.0,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 0),
              width: 200.0,
              height: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 6),
                    width: 190.0,
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                  Container(
                    height: 0.5,
                    width: 400.0,
                    color: Colors.greenAccent,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 6.0, 0, 2.0),
                    alignment: Alignment.topLeft,
                    height: 50.0,
                    width: 190.0,
                    child: Text(
                      desc,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            )
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

  // Container _buildHeaderContainer(
  //     BuildContext context, String name, String image) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 14.0),
  //     child: Row(
  //       children: <Widget>[
  //         Container(
  //           margin: EdgeInsets.only(left: 18.0),
  //           height: 100.0,
  //           width: 100.0,
  //           color: Colors.red,
  //           child: Image.asset('/assets/Categories.png'),
  //           //child: Image.asset(image),
  //         ),
  //         Container(
  //           height: 100.0,
  //           width: 200.0,
  //           alignment: Alignment.bottomCenter,
  //           decoration: BoxDecoration(
  //             color: Colors.blue,
  //             borderRadius: BorderRadius.circular(18.0),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String desc =
      "The world is characterized by diversity – the golden sands of the Sahara are as captivating as the Amazon’s emerald canopies and Antarctica’s pearly stillnesss. These diverging hues are what make the world tick, and we hope to embody this variegation at Techtatva’19 – Embracing Contraries.\n\nTechtatva is a national level technical fest of Manipal Institute of Technology which aims at going beyond circulated PDFs and pictures of notebooks, instead bringing learning to one’s fingertips. We strive to bring out the best in coders, designers, innovators and automobile enthusiasts alike, across their diverse fields and talents.\n\nHumans have come so far because of their ability to hone each talent and direct it towards a united cause.\n\nA day spent perspirating at a workshop while fiddling with tools and components could not be more different from a day spent squinting at a screen with your mind in tangles, but both are quintessential for technology itself to progress.\n\nEach one of us is unique and in this edition of Techtatva, from the 9th to the 12th of October, we strive to embrace our peculiarities and stand as one, and we invite you to stand with us.";
}

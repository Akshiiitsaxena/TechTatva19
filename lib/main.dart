import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techtatva19/pages/Home.dart';
import 'package:techtatva19/pages/Schedule.dart';
import 'package:techtatva19/pages/Categories.dart';
import 'package:techtatva19/pages/Results.dart';
import 'package:techtatva19/pages/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:techtatva19/models/CategoryModel.dart';
import 'package:techtatva19/models/ScheduleModel.dart';
import 'package:techtatva19/models/EventModel.dart';
import 'package:techtatva19/models/DelegateCardModel.dart';
import 'package:techtatva19/models/UserModel.dart';
import 'package:techtatva19/models/ResultModel.dart';

void main() {
  runApp(MyApp());
}

_startUserCache() async {
  try {
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    print(isLoggedIn);

    dio.options.baseUrl = "https://register.techtatva.in";
    dio.options.connectTimeout = 500000000; //5s
    dio.options.receiveTimeout = 300000000;

    if (isLoggedIn) {
      try {
        var resp = await dio.get("/registeredEvents");

        if (resp.statusCode == 200) {
          print(resp.data);
      
        }
      } catch (e) {
    
      }
    }

    if (isLoggedIn) {
      try {
        user = UserData(
            id: int.parse(preferences.getString('userId')),
            name: preferences.getString('userName'),
            regNo: preferences.getString('userReg'),
            mobilNumber: preferences.getString('userMob'),
            emailId: preferences.getString('userEmail'),
            qrCode: preferences.getString('userQR'),
            collegeName: preferences.getString('userCollege'));
      } catch (e) {
        print(e);
      }
    }
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: true,
      title: 'TechTatva',
      theme: ThemeData(
        canvasColor: Colors.black,
        fontFamily: 'Product-Sans',
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

TextStyle headingStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
SharedPreferences preferences;
List<ScheduleData> allSchedule = [];
List<CategoryData> allCategories = [];
List<EventData> allEvents = [];
List<ResultData> allResults = [];
List<DelegateCardModel> allCards = [];

bool isLoggedIn;
bool fromHome;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int _page = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    _startupCache();
    loadCategories();
    loadSchedule();
    loadEvents();
    loadResults();
    loadDelCards();
  }

  _startupCache() async {
    _startUserCache();
    _cacheSchedule();
    _cacheCategories();
    _cacheEvents();
    _cacheResults();
    _cacheDelCards();
  }

  void _cacheDelCards() async {
    try {
      final response = await http
          .get(Uri.encodeFull("https://api.techtatva.in/delegate_cards"));

      if (response == null) return;

      if (response.statusCode == 200)
        preferences.setString('DelegateCards', json.encode(response.body));
    } catch (e) {
      print("problem with del cards");
      print(e);
    }
  }

  void _cacheSchedule() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/schedule"));
      if (response == null) return;
      if (response.statusCode == 200)
        preferences.setString('Schedule', json.encode(response.body));
    } catch (e) {
      print("schedulBT$e");
    }
  }

  void _cacheCategories() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/categories"));
      if (response == null) return;
      if (response.statusCode == 200)
        preferences.setString('Categories', json.encode(response.body));
    } catch (e) {
      print(e);
    }
  }

  void _cacheEvents() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/events"));
      if (response.statusCode == 200)
        preferences.setString('Events', json.encode(response.body));
      if (response == null) return;
    } catch (e) {
      print(e);
      print("error in fetching events");
    }
  }

  void _cacheResults() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/results"));
      if (response.statusCode == 200)
        preferences.setString('Results', json.encode(response.body));
      if (response == null) return;
    } catch (e) {
      print(e);
      print("Error in fetching results");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 1), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  getPage(_pageController) {
    return _pageController.position;
  }

  _buildBottomNavBarItem(String title, Icon icon) {
    return BottomNavigationBarItem(
        backgroundColor: Colors.black,
        activeIcon: icon,
        title: Text(title),
        icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    fromHome = false;

    return SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: (_page == 1 || _page == 2 || _page == 3 || _page == 4)
            ? null
            : AppBar(
                centerTitle: true,
                backgroundColor: Colors.black,
                title: Text(
                  "Home",
                ),
              ),
        // drawer: Drawer(
        //   child: ListView(
        //     children: <Widget>[
        //       UserAccountsDrawerHeader(
        //         decoration: BoxDecoration(color: Colors.black),
        //         accountName: Container(
        //           margin: EdgeInsets.only(top: 30.0),
        //           child: Text(
        //             "TechTatva'19",
        //             style: TextStyle(
        //                 fontWeight: FontWeight.w500,
        //                 fontSize: 20.0,
        //                 color: Colors.greenAccent.withOpacity(0.8)),
        //           ),
        //         ),
        //         accountEmail: Text(
        //           "Embracing Contraries.",
        //           style: TextStyle(
        //               fontWeight: FontWeight.w300, color: Colors.white70),
        //         ),
        //         currentAccountPicture: CircleAvatar(
        //           backgroundImage: AssetImage(
        //             'assets/logo_white.jpg',
        //           ),
        //           radius: 90.0,
        //         ),
        //       ),
        //       Container(
        //         height: 0.5,
        //         margin: EdgeInsets.only(left: 15.0),
        //         color: Colors.greenAccent.withOpacity(1.0),
        //       ),
        //       _buildDrawerTile(FontAwesomeIcons.infoCircle, 'About Us',
        //           "Find out more about TechTatva."),
        //       _buildDrawerTile(Icons.bug_report, 'Report a bug', ""),
        //     ],
        //   ),
        // ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Home(),
            Schedule(),
            Results(),
            LoginPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          onTap: navigationTapped,
          selectedItemColor: Colors.cyan,
          items: [
            _buildBottomNavBarItem("Home", Icon(Icons.home)),
            _buildBottomNavBarItem("Schedule", Icon(Icons.schedule)),
            _buildBottomNavBarItem("Results", Icon(Icons.assessment)),
            _buildBottomNavBarItem("User", Icon(Icons.person))
          ],
        ),
      ),
    );
  }

  _buildDrawerTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20.0,
      ),
      subtitle: Text(subtitle),
      title: Text(title),
      onTap: () {},
    );
  }
}

_fetchEvents() async {
  List<EventData> events = [];

  preferences = await SharedPreferences.getInstance();

  var jsonData;

  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  try {
    String data = preferences.getString('Events') ?? null;

    if (data != null && !isCon) {
      jsonData = jsonDecode(jsonDecode(data));
    } else {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/events"));

      if (response.statusCode == 200) jsonData = json.decode(response.body);
    }

    for (var json in jsonData['data']) {
      try {
        var id = json['id'];
        var categoryId = json['category'];
        var name = json['name'];
        var free = json['free'];
        var description = json['shortDesc'];
        var minTeamSize = json['minTeamSize'];
        var maxTeamSize = json['maxTeamSize'];
        var delCardType = json['delCardType'];
        var visible = json['visible'];
        var canReg = json['can_register'];

        EventData temp = EventData(
            id: id,
            categoryId: categoryId,
            name: name,
            free: free,
            description: description,
            minTeamSize: minTeamSize,
            maxTeamSize: maxTeamSize,
            delCardType: delCardType,
            visible: visible,
            canRegister: canReg);

        events.add(temp);
      } catch (e) {
        print(e);
        print("Error in parsing and fetching events");
      }
    }
  } catch (e) {
    print(e);
  }
  return events;
}

Future<String> loadEvents() async {
  allEvents = await _fetchEvents();
  //print(allEvents.length);
  return "success";
}

Future<String> loadDelCards() async {
  allCards = await _fetchCards();
  print("got card");
  return "success";
}

_fetchCards() async {
  List<DelegateCardModel> cards = [];

  preferences = await SharedPreferences.getInstance();

  var jsonData;
  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  try {
    String data = preferences.getString('DelegateCards') ?? "";
    if (data == "" && isCon) {
      final response = await http
          .get(Uri.encodeFull("https://api.techtatva.in/delegate_cards"));

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
      }
    } else {
      print(data);
      print(jsonDecode(jsonDecode(data)));
      jsonData = jsonDecode(jsonDecode(data));
    }

    for (var json in jsonData['data']) {
      try {
        var id = json['id'];
        var name = json['name'];
        var desc = json['description'];
        var mahePrice = json['MAHE_price'];
        var nonPrice = json['non_price'];
        var forSale = json['forSale'];
        var payMode = json['payment_mode'];

        DelegateCardModel temp = DelegateCardModel(
            id: id,
            name: name,
            desc: desc,
            mahePrice: mahePrice,
            nonMahePrice: nonPrice,
            forSale: forSale,
            paymentMode: payMode);

        cards.add(temp);

      } catch (e) {
        print(e);
      }
    }
  } catch (e) {
    print(e);
  }
  return cards;
}

Future<String> loadResults() async {
  allResults = await _fetchResults();
  return "success";
}

_fetchResults() async {
  List<ResultData> results = [];

  preferences = await SharedPreferences.getInstance();

  var jsonData;

  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  try {
    String data = preferences.getString('Results') ?? null;

    if (data != null && !isCon) {
      print("here res");
      jsonData = jsonDecode(jsonDecode(data));
    } else {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/results"));

      if (response.statusCode == 200) jsonData = json.decode(response.body);
    }

    for (var json in jsonData['data']) {
      try {
        var eventId = json['event'];
        var teamId = json['teamid'];
        var position = json['position'];
        var round = json['round'];

        ResultData temp = ResultData(
          eventId: eventId,
          teamId: teamId,
          position: position,
          round: round,
        );

        results.add(temp);
      } catch (e) {
        print(e);
        print("error in parsing results");
      }
    }
  } catch (e) {
    print(e);
  }
  return results;
}

_fetchCategories() async {
  List<CategoryData> category = [];

  preferences = await SharedPreferences.getInstance();

  var jsonData;

  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  print("ISCONN$isCon");

  try {
    String data = preferences.getString('Categories') ?? "";

    if (data == "" && isCon) {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/categories"));

      if (response.statusCode == 200) jsonData = json.decode(response.body);
    } else {
      jsonData = jsonDecode(jsonDecode(data));
    }

    for (var json in jsonData['data']) {
      try {
        var id = json['id'];
        var name = json['name'];
        var description = json['description'];
        var type = json['type'];
        var cc1Name = json['cc1Name'];
        var cc1Contact = json['cc1Contact'];
        var cc2Name = json['cc2Name'];
        var cc2Contact = json['cc2Contact'];

        // add more with changes to API

        CategoryData temp = CategoryData(
            id: id,
            name: name,
            description: description,
            type: type,
            cc1Contact: cc1Contact,
            cc1Name: cc1Name,
            cc2Contact: cc2Contact,
            cc2Name: cc2Name);

        category.add(temp);
      } catch (e) {
        print("error categories");
      }
    }
  } catch (e) {
    print(e);
  }
  return category;
}

Future<String> loadCategories() async {
  List<CategoryData> temp = await _fetchCategories();
  allCategories.clear();
  try {
    for (var item in temp) {
      if (item.type == "TECHNICAL") {
        allCategories.add(item);
      }
    }
    allCategories.sort((a, b) {
      return a.name.compareTo(b.name);
    });
  } catch (e) {
    print(e);
    return "success";
  }
  //print('${allCategories.length}');
  return "success";
}

_fetchSchedule() async {
  List<ScheduleData> schedule = [];

  preferences = await SharedPreferences.getInstance();

  var jsonData;

  var isCon;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isCon = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isCon = false;
  }

  try {
    String data = preferences.getString('Schedule') ?? "";
    if (data == "" && isCon) {
      final response =
          await http.get(Uri.encodeFull("https://api.techtatva.in/schedule"));

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
      }
    } else {
      print(data);
      print(jsonDecode(jsonDecode(data)));
      jsonData = jsonDecode(jsonDecode(data));
    }

    for (var json in jsonData['data']) {
      try {
        var id = json['id'];
        var eventId = json['eventId'];
        var round = json['round'] ?? 3;
        var name = json['eventName'];
        var categoryId = json['categoryId'];
        var location = json['location'];
        var startTime = DateTime.parse(json['start']);
        var endTime = DateTime.parse(json['end']);

        ScheduleData temp = ScheduleData(
          id: id,
          eventId: eventId,
          round: round,
          name: name,
          categoryId: categoryId,
          startTime: startTime,
          endTime: endTime,
          location: location,
        );

        schedule.add(temp);
      } catch (e) {

        print(e);
      }
    }
  } catch (e) {
    print(e);
  }
  return schedule;
}

Future<String> loadSchedule() async {
  allSchedule = await _fetchSchedule();

  print("Here at least");

  Schedule rem = getInvisibleEvent();

  allSchedule.remove(rem);

  allSchedule.sort((a, b) {
    return a.startTime.compareTo(b.startTime);
  });
  return "success";
}

getInvisibleEvent() {
  int id;
  for (var event in allEvents) {
    print(event.visible);
    if (event.visible == 0) {
      print(event.name);
      id = event.id;
    }
  }

  for (var sched in allSchedule) {
    if (sched.eventId == id) return sched;
  }
}

List<ScheduleData> scheduleForDay(List<ScheduleData> allSchedule, String day) {
  List<ScheduleData> temp = [];

  switch (day) {
    case 'Wednesday':
      for (var i in allSchedule) {
        if (i.startTime.day == 9) temp.add(i);
      }
      break;

    case 'Thursday':
      for (var i in allSchedule) {
        if (i.startTime.day == 10) temp.add(i);
      }
      break;

    case 'Friday':
      for (var i in allSchedule) {
        if (i.startTime.day == 11) temp.add(i);
      }
      break;

    case 'Saturday':
      for (var i in allSchedule) {
        if (i.startTime.day == 12) temp.add(i);
      }
      break;

    default:
      print("ERROR IN DAY WISE PARSINGG");
      break;
  }

  return temp;
}

String getTime(ScheduleData schedule) {
  return '${schedule.startTime.hour.toString()}:${schedule.startTime.minute.toString() == '0' ? '00' : schedule.startTime.minute.toString()} - ${schedule.endTime.hour.toString()}:${schedule.endTime.minute.toString() == '0' ? '00' : schedule.endTime.minute.toString()}';
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }

  static buildSliverAppBar(String name, String image) {
    return SliverAppBar(
      leading: Icon(
        Icons.ac_unit,
        color: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(name, style: headingStyle),
        background: Image.asset(image,
            color: Colors.black.withOpacity(0.55),
            colorBlendMode: BlendMode.darken,
            fit: BoxFit.cover),
        collapseMode: CollapseMode.parallax,
      ),
      actions: <Widget>[],
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/Screens/Home.dart';
import 'package:secondhand/Screens/createacc.dart';
import 'package:secondhand/Screens/onboardingstate.dart';
import 'package:secondhand/Screens/posting.dart';
import 'package:secondhand/Screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print('firebase initialized'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? isfirsttime;
  bool? islogedin;
  @override
  void initState() {
    super.initState();
    isfirstime();
    islogedinf();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => isfirsttime ?? true
            ? OnboardingState()
            : islogedin ?? true
                ? Home()
                : Login(),
        '/login': (context) => Login(),
        '/createacc': (context) => const Createacc(),
        '/home': (context) => const Home(),
        '/post': (context) => const Posting(),
        '/profile': (context) => const Profile(),
      },
    );
  }

  isfirstime() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    isfirsttime = preference.getBool('firsttime');
    setState(() {});
  }

  islogedinf() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    islogedin = preference.getBool('logedin');
    print(islogedin);
    setState(() {});
  }
}

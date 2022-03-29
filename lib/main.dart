import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/Screens/home.dart';
import 'package:secondhand/Screens/chats.dart';
import 'package:secondhand/Screens/chatscreen.dart';
import 'package:secondhand/Screens/forgotpassword.dart';
import 'package:secondhand/Screens/createacc.dart';
import 'package:secondhand/Screens/onboardingstate.dart';
import 'package:secondhand/Screens/posting.dart';
import 'package:secondhand/Screens/profile.dart';
import 'package:secondhand/Screens/search.dart';
import 'package:secondhand/classes/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Login.dart';
import 'Screens/sellersprofile.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp( const MyHomePage());
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? isfirsttime;
  bool? islogedin;
  bool? isdark;
  @override
  void initState() {
    super.initState();
    isfirstime();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isdark?? false ?darkTheme :lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => isfirsttime ?? true
            ? OnboardingState()
            : islogedin ?? true
                ? const Home()
                : const Login(),
        '/login': (context) => const Login(),
        '/createacc': (context) => const Createacc(),
        '/home': (context) => const Home(),
        '/post': (context) => const Posting(),
        '/profile': (context) => const Profile(),
        '/sellersprofile': (context) =>  const SellersProfile(),
        '/forgotpassword': (context) =>  const Forgotpassword(),
        '/chat': (context) =>  const ChatScreen(),
        '/chats': (context) =>  const Chats(),
        '/search': (context) =>  const Search(),
      },
    );
  }

  isfirstime() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    isfirsttime = preference.getBool('firsttime');
   islogedin = preference.getBool('logedin');
   isdark = preference.getBool('isdark');
    setState(() {});
  }
}

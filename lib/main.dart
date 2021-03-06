import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:secondhand/Screens/home.dart';
import 'package:secondhand/Screens/chats.dart';
import 'package:secondhand/Screens/chatscreen.dart';
import 'package:secondhand/Screens/forgotpassword.dart';
import 'package:secondhand/Screens/createacc.dart';
import 'package:secondhand/Screens/onboardingstate.dart';
import 'package:secondhand/Screens/posting.dart';
import 'package:secondhand/Screens/profile.dart';
import 'package:secondhand/Screens/profilediting.dart';
import 'package:secondhand/Screens/search.dart';
import 'package:secondhand/classes/localeprovider.dart';
import 'package:secondhand/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Login.dart';
import 'Screens/sellersprofile.dart';
import 'package:flutter_gen/gen_l10n/app_local_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isfirsttime = false;
  bool? islogedin;
  bool? isdark;
  @override
  void initState() {
    super.initState();
    isfirstime();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData.light(),
        initial: AdaptiveThemeMode.system,
        dark: ThemeData.dark(),
        builder: (light, dark) => ChangeNotifierProvider(
            create: (context) => LocaleProvider(),
            builder: (context, child) {
              final provider = Provider.of<LocaleProvider>(context);
              return MaterialApp(
                  locale: provider.locale,
                  supportedLocales: L10n.all,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  theme: light,
                  darkTheme: dark,
                  initialRoute: '/',
                  routes: {
                '/': (context) =>  !isfirsttime 
                        ?islogedin ?? true
                            ? const Home()
                            : const Login() 
                        : OnboardingState(),
                    '/login': (context) => const Login(),
                    '/createacc': (context) => const Createacc(),
                    '/home': (context) => const Home(),
                    '/post': (context) => const Posting(),
                    '/profile': (context) => const Profile(),
                    '/sellersprofile': (context) => const SellersProfile(),
                    '/forgotpassword': (context) => const Forgotpassword(),
                    '/chat': (context) => const ChatScreen(),
                    '/chats': (context) => const Chats(),
                    '/search': (context) => const Search(),
                    '/profiledit': (context) => const Profiledit(),
                  });
            }));
  }

  isfirstime() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    isfirsttime = preference.getBool('firsttime') ?? false;
    islogedin = preference.getBool('logedin');
    isdark = preference.getBool('isdark');
    setState(() {});
  }
}

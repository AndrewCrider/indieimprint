import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../data/DatabaseWrite.dart';
import '../services/appConfig.dart';
import 'package:indieimprint/mainWidgets/MainWidgetsIndex.dart';
import 'package:indieimprint/services/authentication.dart';
import 'package:indieimprint/services/retrieveIssues.dart';
import 'package:indieimprint/widgets/BottomNavBar.dart';
import 'package:indieimprint/widgets/authenticationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.iosflatline,
  );

  //User? user = await authentication.logInAnonymously();
  await DatabaseWrite.purchaseDatabaseInit();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  AppConfig.create(
  appOwner: "Flatline Comics",
  baseUrl: "",
  primaryColor:Colors.redAccent,
  flavor: Flavor.flatline,
  );

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("${AppConfig.shared.appOwner} in main build");

    return MaterialApp(
      title: 'Flatline Comics',
      theme: ThemeData(

        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
      routes: {
        'mainScreen' : (context) => MyHomePage(title: AppConfig.shared.appOwner)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentIndex = 0;
  authentication authService = new authentication();
  bool authState = false;

  final List<Widget> _pages = [
    StorePage(),
    LibraryPage(),
    LibraryPage(),
    AboutPage(),
    SettingsPage(),
  ];

  @override
  void initState() {

    super.initState();
    checkForUser();
  }

  Future<void> checkForUser() async {
    User? user = authService.getCurrentUser();

    if (user != null ){
      print("in if for user - $user");
      setState(() {
        print("in set state user - $user");
        authState = true;
      });
      await fetchIssueforPublisher("Flatline Comics");
    } else {
      setState(){}
    }
  }

  void _simulateException() {
    throw Exception("Simulated Exception");
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateException,
        child: Icon(Icons.error),
      ),
      body: SafeArea(
        child: authState ? Stack(
          children: [

            Positioned.fill(
              child: _pages[_currentIndex],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavBar(
                currentIndex: _currentIndex,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ) :
        authenticationScreen(),
      ),)
      ;

  }
}

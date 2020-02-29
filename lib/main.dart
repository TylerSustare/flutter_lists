import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/app_state.dart';
import 'package:flutter_lists/views/add_item.dart';
import 'package:flutter_lists/views/home.dart';
import 'package:flutter_lists/views/settings.dart';
import 'package:provider/provider.dart';

// void main() => runApp(MyApp());
Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final FirebaseApp app = await FirebaseApp.configure(
  //   name: 'test',
  //   options: const FirebaseOptions(
  //     googleAppID: '1:79601577497:ios:5f2bcc6ba8cecddd',
  //     gcmSenderID: '79601577497',
  //     apiKey: 'AIzaSyArgmRGfB5kiQT6CunAOmKRVKEsxKmy6YI-G72PVU',
  //     projectID: 'flutter-firestore',
  //   ),
  // );
  // final Firestore firestore = Firestore(app: app);
  // await firestore.collection('toast').add(<String, dynamic>{
  //   'message': 'Hello world!',
  // });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Provider.of<AppState>(context).theme),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/home': (context) => MyHomePage(),
        '/add-item': (context) => AddItem(),
        '/settings': (context) => Settings(),
      },
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}

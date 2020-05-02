import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/app_state.dart';
import 'package:flutter_lists/services/auth.dart';
import 'package:flutter_lists/views/add_item.dart';
import 'package:flutter_lists/views/home.dart';
import 'package:flutter_lists/views/list_detail.dart';
import 'package:flutter_lists/views/login.dart';
import 'package:flutter_lists/views/settings.dart';
import 'package:provider/provider.dart';

// void main() => runApp(MyApp());
Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        StreamProvider<FirebaseUser>.value(value: AuthService().user),
      ],
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Provider.of<AppState>(context).theme,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeView(),
        '/collection': (context) => CollectionView(),
        '/add-item': (context) => AddItem(),
        '/settings': (context) => Settings(),
      },
      navigatorObservers: <NavigatorObserver>[FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}

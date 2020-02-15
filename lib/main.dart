import 'package:flutter/material.dart';
import 'package:flutter_lists/app_state.dart';
import 'package:flutter_lists/views/add_item.dart';
import 'package:flutter_lists/views/home.dart';
import 'package:flutter_lists/views/settings.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

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
    );
  }
}

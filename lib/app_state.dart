import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int counter = 0;
  String title = 'Flutter Demo Home Page';

  Brightness theme = Brightness.light;

  void incrementCouter() {
    counter += 1;
    notifyListeners();
  }

  void toggleDark() {
    theme = theme == Brightness.dark ? Brightness.light : Brightness.dark;
    notifyListeners();
  }
}

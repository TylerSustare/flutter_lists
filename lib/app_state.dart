import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int counter = 0;
  String title = 'Flutter Demo Home Page';
  String activeList;

  Brightness theme = Brightness.dark;

  void incrementCouter() {
    counter += 1;
    notifyListeners();
  }

  void toggleDark() {
    theme = theme == Brightness.dark ? Brightness.light : Brightness.dark;
    notifyListeners();
  }

  void setActiveList({listId: String}) {
    activeList = listId;
    notifyListeners();
  }
}

// Provider.of<AppState>(context, listen: false).incrementCouter();
// Provider.of<AppState>(context, listen: false).toggleDark();

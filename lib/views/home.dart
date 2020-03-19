import 'package:flutter/material.dart';
import 'package:flutter_lists/app_state.dart';
import 'package:flutter_lists/shared/list_of_lists.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
        ),
        title: Text(Provider.of<AppState>(context).title),
      ),
      body: Center(
        child: ListOfLists(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, '/add-item');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

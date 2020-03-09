import 'package:flutter/material.dart';
import 'package:flutter_lists/app_state.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${Provider.of<AppState>(context).counter}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Provider.of<AppState>(context, listen: false).incrementCouter();
          // Provider.of<AppState>(context, listen: false).toggleDark();
          // Navigator.pushNamed(context, '/add-item');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

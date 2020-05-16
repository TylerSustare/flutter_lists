import 'package:flutter/material.dart';
import 'package:flutter_lists/shared/add_list_item_form.dart';

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item to a List'),
      ),
      body: ListView(
        children: <Widget>[
          Container(child: AddItemToList()),
        ],
      ),
    );
  }
}

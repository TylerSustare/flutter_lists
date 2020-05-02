import 'package:flutter/material.dart';
import 'package:flutter_lists/shared/collection.dart';

class CollectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: Center(
        child: Collection(),
      ),
    );
  }
}

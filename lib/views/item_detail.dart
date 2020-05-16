import 'package:flutter/material.dart';
import 'package:flutter_lists/shared/detail.dart';

class ItemDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Detail(),
      ),
    );
  }
}

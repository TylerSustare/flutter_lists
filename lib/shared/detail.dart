import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/services/list.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final uid = user.uid;
    final activeList = Provider.of<AppState>(context).activeList;
    final activeItem = Provider.of<AppState>(context).activeItem;
    return StreamBuilder<DocumentSnapshot>(
      stream: ListService.getItem(list: activeList, uid: uid, item: activeItem),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        var item = snapshot.data;
        return Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Center(
                  child: Text(item.data['title']),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

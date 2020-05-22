import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/services/list.dart';
import 'package:flutter_lists/shared/detail.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class Collection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final uid = user.uid;
    final activeList = Provider.of<AppState>(context).activeList;
    return StreamBuilder<QuerySnapshot>(
      stream: ListService.getList(list: activeList, uid: uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        if (snapshot.data.documents == null) return Text('Add a list to get started');
        List<DocumentSnapshot> lists = snapshot.data.documents;
        return Container(
          child: ListView.builder(
            itemCount: lists.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key('${lists[index]}-$index'),
                child: ListTile(
                  title: Text(lists[index].data['title']),
                  onTap: () {
                    Provider.of<AppState>(context, listen: false).setActiveItem(itemId: lists[index].data['title']);
                    Navigator.pushNamed(context, '/detail');
                  },
                  // trailing: ImageDetail( uid: uid, imageKey: lists[index].data['imageKey'],),
                ),
                background: Container(color: Colors.red),
                confirmDismiss: (DismissDirection direction) async {
                  final bool res = await showDeleteThingDialog(context, 'List');
                  return res;
                },
                onDismissed: (DismissDirection direction) async =>
                    ListService.removeAt(index: index, list: lists, uid: uid),
              );
            },
          ),
        );
      },
    );
  }
}

Future<bool> showDeleteThingDialog(BuildContext context, String deleteThisThing) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete this $deleteThisThing"),
        content: Text("Are you sure you wish to delete this $deleteThisThing? You can't get it back."),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("DELETE"),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("CANCEL"),
          ),
        ],
      );
    },
  );
}

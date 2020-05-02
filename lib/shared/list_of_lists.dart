import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/services/list.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class ListOfLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final uid = user.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: ListService.getUserLists(uid: uid),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        if (snapshot.data.data == null || snapshot.data.data['lists'] == null) {
          return Text('Add a list to get started');
        }
        List<dynamic> lists = snapshot.data.data['lists'];
        return Container(
          child: ListView.builder(
            itemCount: lists.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key('${lists[index]}-$index'),
                child: ListTile(
                  title: Text(lists[index]),
                  onTap: () {
                    Provider.of<AppState>(context, listen: false).setActiveList(listId: lists[index]);
                    Navigator.pushNamed(context, '/collection');
                  },
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

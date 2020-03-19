import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/services/list.dart';
import 'package:provider/provider.dart';

class ListOfLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final uid = user.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('lists').document(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        if (snapshot.data.data == null) Text('Add a list to get started');
        List<dynamic> lists = snapshot.data.data['lists'];
        return Container(
          child: ListView.builder(
            itemCount: lists.length,
            itemBuilder: (BuildContext context, int index) {
              // return Text(lists[index]);
              return Dismissible(
                key: Key('${lists[index]}-$index'),
                child: ListTile(
                  title: Text(lists[index]),
                ),
                background: Container(color: Colors.red),
                onDismissed: (DismissDirection direction) async {
                  ListService().removeAt(index: index, list: lists, uid: uid);
                },
              );
            },
          ),
        );
      },
    );
  }
}

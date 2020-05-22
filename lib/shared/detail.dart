import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(item.data['title']),
                      ),
                      item.data['imageKey'] != null
                          ? ImageDetail(uid: uid, imageKey: item.data['imageKey'])
                          : SizedBox.shrink(), // like a <></> in react
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class ImageDetail extends StatelessWidget {
  ImageDetail({@required this.uid, @required this.imageKey});
  final String uid;
  final String imageKey;

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: FirebaseStorage().ref().child('/${this.uid}/${this.imageKey}').getDownloadURL(),
        initialData: '',
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data == '') {
            return CircularProgressIndicator();
          }
          return Image.network(snapshot.data);
        },
      );
}

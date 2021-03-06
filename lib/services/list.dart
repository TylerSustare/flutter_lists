import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/item.dart';

class ListService {
  static Future<void> saveItem({uid: String, list: String, title: String, description: String, imageKey: String}) {
    DocumentReference uidDocumentRef = Firestore.instance.collection('lists').document(uid);
    return Firestore.instance.runTransaction(
      (Transaction t) => t.get(uidDocumentRef).then((DocumentSnapshot uidDocument) async {
        List currentLists = [];
        if (uidDocument.data != null) {
          currentLists = uidDocument.data['lists'];
        }
        if (!currentLists.contains(list)) {
          currentLists.add(list);
        }
        if (uidDocument.data == null) {
          // set the first piece of data on this document being the `lists` object
          await uidDocumentRef.setData(<String, dynamic>{'lists': currentLists});
        } else {
          // if document exists, update as part of the transaction
          await t.update(uidDocumentRef, <String, dynamic>{'lists': currentLists});
        }
        return Firestore.instance
            .collection('lists')
            .document(uid)
            .collection(list)
            .document(title)
            .setData(Item(description: description, imageKey: imageKey, title: title).toMap());
      }),
    );
  }

  static Future<void> removeAt({List<dynamic> list, index: int, uid: String}) async {
    ///! deleting collections kinda sucks https://cloud.google.com/firestore/docs/manage-data/delete-data
    /// TODO: make a cloud function that responds to this and deletes the collection associated to the entry in the list
    list.removeAt(index);
    await Firestore.instance.collection('lists').document(uid).setData(<String, dynamic>{'lists': list});
  }

  static Stream<DocumentSnapshot> getUserLists({uid: String}) {
    return Firestore.instance.collection('lists').document(uid).snapshots();
  }

  static Stream<QuerySnapshot> getList({uid: String, list: String}) {
    return Firestore.instance.collection('lists').document(uid).collection(list).snapshots();
  }

  static Stream<Item> getItem({uid: String, list: String, item: String}) {
    return Firestore.instance
        .collection('lists')
        .document(uid)
        .collection(list)
        .document(item)
        .snapshots()
        .map((DocumentSnapshot v) => Item.fromMap(v.data));
  }

  static Future<String> proofOfConceptThing({list, uid: String}) async {
    final Firestore firestore = Firestore();
    var itemsInList = await Firestore.instance.collection('lists').document(uid).collection(list).getDocuments();
    print(itemsInList);
    QuerySnapshot items = await firestore.collection(uid).getDocuments(); // this gets all sub collections as well
    List<DocumentSnapshot> data = items.documents.toList(); // for querysnapshot
    // DocumentSnapshot items = await firestore .collection(uid) /* .where('fields' != null)*/ .document('test') .get();
    // Map<String, dynamic> data = items.data; // for document snapshots
    String returnData = '';
    // data.forEach((e) => returnData += e.data.toString()); // all data for the whole document
    data.forEach((e) => returnData += e.documentID.toString() + '\n'); // all data for the whole document
    print('getItems -> data');
    print(data);
    // return data.toString();
    return returnData;
  }
}

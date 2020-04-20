import 'package:cloud_firestore/cloud_firestore.dart';

class ListService {
  Future<void> saveItem({uid, list, item: String}) {
    // https://firebase.google.com/docs/firestore/manage-data/transactions
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
        await t.update(uidDocumentRef, <String, dynamic>{'lists': currentLists});
        return Firestore.instance
            .collection('lists')
            .document(uid)
            .collection(list)
            .add(<String, dynamic>{'item': item});
      }),
    );
  }

  /// deleting collections kinda sucks https://cloud.google.com/firestore/docs/manage-data/delete-data
  /// TODO: make a cloud function that responds to this and deletes the collection associated to the entry in the list
  /// https://medium.com/google-cloud/firebase-developing-serverless-functions-in-go-963cb011265d
  Future<void> removeAt({List<dynamic> list, index: int, uid: String}) async {
    list.removeAt(index);
    await Firestore.instance.collection('lists').document(uid).setData(<String, dynamic>{'lists': list});
  }

  Stream<List> getUserLists({uid: String}) {
    return Firestore.instance.collection('lists').document(uid).snapshots().map((v) => v.data['lists'] as List);

    // this is how you get data out of a stream, you have to unsubscribe without a Streambuilder
    // await for (var val in ListService().getUserLists(uid: uid)) {
    // print(val);
    // }
  }

  Future<String> getItemsFromList({list, uid: String}) async {
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

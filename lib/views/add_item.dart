import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final uid = user.uid;
    return FutureBuilder(
      future: getItems(uid: uid),
      initialData: '',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(snapshot.data ?? '');
      },
    );
  }
}

class LOL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final uid = user.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('lists').document(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return Container(
          child: Text(snapshot.data.data.values.toString() ?? ''),
        );
      },
    );
  }
}

Future<String> getItems({uid: String}) async {
  final Firestore firestore = Firestore();
  QuerySnapshot items = await firestore
      .collection(uid)
      .getDocuments(); // this gets all sub collections as well
  List<DocumentSnapshot> data = items.documents.toList(); // for querysnapshot
  // DocumentSnapshot items = await firestore .collection(uid) /* .where('fields' != null)*/ .document('test') .get();
  // Map<String, dynamic> data = items.data; // for document snapshots
  String returnData = '';
  // data.forEach((e) => returnData += e.data.toString()); // all data for the whole document
  data.forEach((e) => returnData +=
      e.documentID.toString() + '\n'); // all data for the whole document
  print('getItems -> data');
  print(data);
  // return data.toString();
  return returnData;
}

Future<void> saveItem({uid, list, item: String}) async {
  // WidgetsFlutterBinding.ensureInitialized();
  final Firestore firestore = Firestore();
  var items = await firestore
      .collection('lists')
      .document(uid)
      .collection(list)
      .getDocuments();
  print('items');
  print(items.documents);

  var uidDocument = await firestore.collection('lists').document(uid).get();
  print('uidDocument');
  List currentLists = uidDocument.data['lists'] ?? [];
  print(currentLists);
  if (!currentLists.contains(list)) {
    currentLists.add(list);
  }
  List newItems = [];
  // if (items.data != null) {
  // newItems = items.data['item'];
  // }
  print('newItems');
  print(newItems);
  newItems.add(item);
  await firestore
      .collection('lists')
      .document(uid)
      .setData(<String, dynamic>{'lists': currentLists});
  return firestore
      .collection('lists')
      .document(uid)
      .collection(list)
      .add(<String, dynamic>{'item': newItems});
}

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item to a List'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: AddPlayerForm(),
          ),
          Container(
            // child: ListOfLists(),
            child: LOL(),
          ),
        ],
      ),
    );
  }
}

// Create a Form widget.
class AddPlayerForm extends StatefulWidget {
  @override
  AddPlayerFormState createState() => AddPlayerFormState();
}

// Create a corresponding State class.
// This class holds data related to the form. Disposes of "controller" as well from the `dispose()` method
class AddPlayerFormState extends State<AddPlayerForm> {
  AddPlayerFormState();

  // Create a global key that uniquely identifies the Form widget and allows validation of the form.
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<AddPlayerFormState>.
  final _formKey = GlobalKey<FormState>();
  final listController = TextEditingController();
  final itemController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: listController,
                decoration: InputDecoration(
                  labelText: 'List',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'List name can\'t be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: itemController,
                decoration: InputDecoration(
                  labelText: 'Item',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Item name can\'t be empty';
                  }
                  return null;
                },
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, false if not
                        if (_formKey.currentState.validate()) {
                          try {
                            // If the form is valid, display a Snackbar.
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added "${listController.text}" to game...',
                                ),
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.pinkAccent,
                              ),
                            );
                            await saveItem(
                                uid: user.uid,
                                list: listController.text,
                                item: itemController.text);
                          } catch (e) {
                            print(e);
                          }
                          listController.clear();
                          itemController.clear();
                        }
                      },
                      child: Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      // color: Provider.of<AppState>(context).color,
                      color: Colors.blue,
                      key: new Key('add-player-to-game'),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

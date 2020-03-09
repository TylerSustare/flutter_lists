import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String> getItems() async {
  final Firestore firestore = Firestore();
  // var items = await firestore.collection('toast').getDocuments(); // this gets all sub collections as well
  DocumentSnapshot items = await firestore
      .collection('toast')
      // .where('fields' != null)
      // .getDocuments();
      .document('test')
      .get();
  // var data = items.documents.toList(); // for querysnapshot
  var data = items.data;
  // String returnData = '';
  // data.forEach((e) => returnData += e.data.toString());
  print('\n\n\n');
  print(data);
  print('\n\n\n');
  return data.toString();
  // .data.toString();
}

Future<void> saveItem({list, item: String}) async {
  // WidgetsFlutterBinding.ensureInitialized();
  final Firestore firestore = Firestore();
  final lists = await firestore.collection('toast').document('lists').get();
  print('\n\n\n');
  print(lists.data);
  print('\n\n\n');
  if (lists.data != null && !lists.data.containsValue(list)) {
    var newList = [...lists.data as List];
    await firestore
        .collection('toast')
        .document('lists')
        .setData(<String, dynamic>{'lists': newList});
  }
  var items = await firestore.collection('toast').document(list).get();
  List newItems = items.data['item'];
  newItems.add(item);
  return firestore
      .collection('toast')
      // .add(<String, dynamic>{'list': list, 'item': item});
      .document(list)
      .setData(<String, dynamic>{'item': newItems});
}

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item to a List'),
      ),
      body: Container(
        child: AddPlayerForm(),
      ),
    );
  }
}

class ListOfLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getItems(),
      initialData: '',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(snapshot.data);
      },
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
              ListOfLists(),
            ],
          ),
        ),
      ),
    );
  }
}

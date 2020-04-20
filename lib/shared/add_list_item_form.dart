// Create a Form widget.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/services/list.dart';
import 'package:provider/provider.dart';

class AddItemToList extends StatefulWidget {
  @override
  AddItemToListState createState() => AddItemToListState();
}

// Create a corresponding State class.
// This class holds data related to the form. Disposes of "controller" as well from the `dispose()` method
class AddItemToListState extends State<AddItemToList> {
  AddItemToListState();

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
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.pinkAccent,
                              ),
                            );
                            await ListService().saveItem(
                              uid: user.uid,
                              list: listController.text,
                              item: itemController.text,
                            );
                          } catch (e) {
                            print(e);
                          }
                          listController.clear();
                          itemController.clear();
                          Navigator.pop(context);
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/services/list.dart';
import 'package:provider/provider.dart';

class AddItemToList extends StatefulWidget {
  @override
  AddItemToListState createState() => AddItemToListState();
}

class AddItemToListState extends State<AddItemToList> {
  AddItemToListState();

  final _formKey = GlobalKey<FormState>();
  final listController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void dispose() {
    listController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

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
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Title name can\'t be empty';
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
                        await validateAndSave(
                          context: context,
                          formKey: _formKey,
                          titleController: titleController,
                          listController: listController,
                          user: user,
                        );
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

Future<void> validateAndSave({
  BuildContext context,
  GlobalKey<FormState> formKey,
  FirebaseUser user,
  TextEditingController listController,
  TextEditingController titleController,
}) async {
  if (formKey.currentState.validate()) {
    try {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added "${titleController.text}" to ${listController.text}',
          ),
          duration: Duration(seconds: 2),
        ),
      );
      await ListService.saveItem(
        uid: user.uid,
        list: listController.text.trim(),
        title: titleController.text.trim(),
      );
    } catch (e) {
      print(e);
    }
    listController.clear();
    titleController.clear();
    Navigator.pop(context);
  }
}

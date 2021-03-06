import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lists/services/list.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddItemToList extends StatefulWidget {
  @override
  AddItemToListState createState() => AddItemToListState();
}

class AddItemToListState extends State<AddItemToList> {
  AddItemToListState();

  final _formKey = GlobalKey<FormState>();
  final listController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  File _image;
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future getPhoto() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

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
                decoration: InputDecoration(labelText: 'List'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'List name can\'t be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Title name can\'t be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Description name can\'t be empty';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                child: Row(
                  children: <Widget>[
                    _image == null
                        ? Text('No image selected.')
                        : Image.file(_image, width: MediaQuery.of(context).size.width - 75, fit: BoxFit.scaleDown),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              Row(
                children: <Widget>[
                  FlatButton(onPressed: getPhoto, child: Icon(Icons.add_a_photo)),
                  FlatButton(onPressed: getImage, child: Icon(Icons.add_photo_alternate)),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () async {
                        String imageKey = new Uuid().v4();
                        if (_image != null) {
                          try {
                            final StorageReference ref = FirebaseStorage().ref().child('/${user.uid}/$imageKey');
                            ref.putFile(_image); //? uploads in the background b/c firebase storage is slow AF
                            //! the following is how to wait for the file to upload
                            // final StorageUploadTask uploadTask = ref.putFile(_image);
                            // await uploadTask.onComplete;
                          } catch (e) {
                            print('Encountered an error uploading file $e');
                          }
                        }
                        await validateAndSave(
                          context: context,
                          formKey: _formKey,
                          titleController: titleController,
                          listController: listController,
                          descriptionController: descriptionController,
                          user: user,
                          imageKey: _image != null ? imageKey : null,
                        );
                      },
                      child: Icon(Icons.add, color: Colors.white),
                      // color: Provider.of<AppState>(context).color,
                      color: Colors.blue,
                      key: new Key('add-item-to-list'),
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
  TextEditingController descriptionController,
  String imageKey,
}) async {
  if (formKey.currentState.validate()) {
    try {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "${titleController.text}" to ${listController.text}'),
          duration: Duration(seconds: 5),
        ),
      );
      print(imageKey);
      await ListService.saveItem(
        uid: user.uid,
        list: listController.text.trim(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imageKey: imageKey,
      );
    } catch (e) {
      print(e);
    }
    listController.clear();
    titleController.clear();
    Navigator.pop(context);
  }
}

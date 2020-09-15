import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:memeadmin/screens/adminapp.dart';
import 'package:memeadmin/screens/newcategories.dart';
import 'package:memeadmin/services/crud.dart';
import 'package:memeadmin/services/networkhandler.dart';
import 'package:http/http.dart' as http;

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  addmethods addObj = addmethods();
  final networkHandler = Networkhandling();
  final CollectionReference ref = Firestore.instance.collection('categories');
  List<String> kindi = ['one', 'two', 'three'];
  List<String> menuitems;
  File SampleImage;
  String url;
  String btn1;
  var selecteditem;
  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Job done',
              style: TextStyle(fontSize: 15.0),
            ),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future getImage() async {
    var temp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      SampleImage = temp;
    });
    var res =
        await networkHandler.patchImage('/memes/add/image', SampleImage.path);
    var body = json.decode(res.body);
    url = body["url"].toString();
    print(url);
  }

  // void uploadimg() async {
  //   final StorageReference StorageRef =
  //       FirebaseStorage.instance.ref().child('Classimgs');
  //   var timekey = DateTime.now();
  //   final StorageUploadTask task =
  //       StorageRef.child(timekey.toString() + ".jpg").putFile(SampleImage);
  //   var imgurl = await (await task.onComplete).ref.getDownloadURL();
  //   url = imgurl.toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('New Category'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewCategory()));
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Add Meme'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.games),
              title: Text('General Meme'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => General()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('General Meme'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 300,
                  width: 200,
                  color: Colors.grey,
                  child: SampleImage == null
                      ? Center(child: Text('Select an Image'))
                      : Image.file(
                          SampleImage,
                          height: 300,
                          width: 200,
                        ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  color: Colors.green,
                  child: Text('choose an image'),
                  onPressed: () async {
                    getImage();
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  color: Colors.green,
                  onPressed: () async {
                    Map<String, String> data = {
                      'imgUrl': this.url,
                    };
                    print(data);
                    var response =
                        await networkHandler.post('/memes/genMeme', data);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      print(response.body);
                      dialogTrigger(context);
                    }
                  },
                  child: Text('Upload data'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

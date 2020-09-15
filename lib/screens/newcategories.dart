import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memeadmin/screens/adminapp.dart';
import 'package:memeadmin/screens/general.dart';
import 'package:memeadmin/services/crud.dart';
import 'package:memeadmin/services/networkhandler.dart';
import 'package:http/http.dart' as http;

class NewCategory extends StatefulWidget {
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  addmethods addObj = addmethods();
  File SampleImage;
  String catname;
  String url;
  final networkHandler = Networkhandling();

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
    // uploadimg();
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
          title: Text('New Category'),
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
                    height: 200,
                    width: 400,
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
                  // TextField(
                  //   decoration: InputDecoration(hintText: 'ImgUrl'),
                  //   onChanged: (value) {
                  //     this.imgUrl = value;
                  //   },
                  // ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Category Name'),
                    onChanged: (value) {
                      this.catname = value;
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
                        'catname': this.catname,
                      };
                      print(data);
                      var response =
                          await networkHandler.post('/memes/addMeme', data);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        print(response.body);
                        dialogTrigger(context);
                      }
                      // if (response.statusCode == 200 ||
                      //     response.statusCode == 201) {
                      //   if (SampleImage.path != null) {
                      //     var imgResponse = await networkHandler.patchImage(
                      //         "kindi", SampleImage.path);
                      //     if (imgResponse.statusCode == 200 ||
                      //         imgResponse.statusCode == 201) {
                      //       dialogTrigger(context);
                      //     }
                      //   }
                      // }
                    },
                    child: Text('Upload data'),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

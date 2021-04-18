import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/model/products_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UploadProducts extends StatefulWidget {
  @override
  _UploadProductsState createState() => _UploadProductsState();
}

class _UploadProductsState extends State<UploadProducts> {
  File _imageFile;
  bool isLoading = false;
  bool isView = true;

  TextEditingController _titleEditController = TextEditingController();
  TextEditingController _descEditController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Products'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  _imageFile == null
                      ? Text('No Image Choosen')
                      : Image.file(
                          _imageFile,
                          width: 150,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Visibility(
                      visible: isView,
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        iconSize: 50,
                        onPressed: () {
                          setState(() {
                            isView = !isView;
                          });
                          pickImage();
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      controller: _titleEditController,
                      decoration: InputDecoration(
                          hintText: 'Enter Title',
                          labelText: 'Title',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      controller: _descEditController,
                      decoration: InputDecoration(
                          hintText: 'Enter Description',
                          labelText: 'Description',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      uploadStatus();
                    },
                    child: Text('Upload Products'),
                    textColor: Colors.white,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
    );
  }

  Future pickImage() async {
    var file = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(file.path);
    });
  }

  uploadStatus() async {
    setState(() {
      isLoading = true;
    });

    var imageUpload = await uploadImage();

    ProductModel productModel = new ProductModel();

    productModel.imageURL = imageUpload.toString();
    productModel.title = _titleEditController.text;
    productModel.desc = _descEditController.text;

    String docId = FirebaseFirestore.instance.collection("products").doc().id;

    productModel.docid = docId;

    await FirebaseFirestore.instance
        .collection("products")
        .doc(productModel.docid)
        .set(productModel.toMap());

    Fluttertoast.showToast(msg: 'Uploaded Successfully');
    Navigator.pop(context);

    setState(() {
      isLoading = false;
    });
  }

  Future<dynamic> uploadImage() async {
    // setState(() {
    //   isLoading = true;
    // });
    var storageReference = FirebaseStorage.instance.ref().child('products');

    var storageUploadTask = await storageReference
        .child("image_" + DateTime.now().toIso8601String())
        .putFile(_imageFile);

    var snapshot = storageUploadTask;

    var downloadURL = await snapshot.ref.getDownloadURL();

    // Fluttertoast.showToast(msg: 'Image Uploaded Successful');

    // setState(() {
    //   isLoading = false;
    // });
    print('downloadURL $downloadURL');
    return downloadURL;
  }
}

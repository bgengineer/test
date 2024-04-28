import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityAddPage extends StatefulWidget {
  const CommunityAddPage({Key? key}) : super(key: key);

  @override
  _CommunityAddPageState createState() => _CommunityAddPageState();
}

class _CommunityAddPageState extends State<CommunityAddPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  TextEditingController _imageNameController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Community Image'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: selectImage,
                icon: Icon(Icons.add_a_photo),
                label: Text('Select Image'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _imageNameController,
                decoration: InputDecoration(
                  labelText: 'Image Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _positionController,
                decoration: InputDecoration(
                  labelText: 'Position',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_selectedFile != null &&
                            _imageNameController.text.isNotEmpty &&
                            _positionController.text.isNotEmpty) {
                          uploadFunction(
                            _selectedFile!,
                            _imageNameController.text,
                            _positionController.text,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please select an image, enter a name and position')),
                          );
                        }
                      },
                      child: Text('UPLOAD'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    try {
      final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          _selectedFile = img;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadFunction(
      XFile imageFile, String imageName, String position) async {
    setState(() {
      isUploading = true;
    });

    try {
      Reference reference =
          _storageRef.ref().child("community").child(imageName);
      UploadTask uploadTask = reference.putFile(File(imageFile.path));
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String imageURL = await storageTaskSnapshot.ref.getDownloadURL();

      await _firestore.collection('community').add({
        'imageName': imageName,
        'imageURL': imageURL,
        'position': position,
      });

      setState(() {
        isUploading = false;
        _selectedFile = null;
        _imageNameController.clear();
        _positionController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully')),
        );
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image')),
      );
    }
  }
}

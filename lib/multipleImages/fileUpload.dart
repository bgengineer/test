import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_test/multipleImages/DisplayImage.dart';
import 'package:image_test/multipleImages/ImageFolder.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  List<String> _arrImageUrls = [];
  int uploadItem = 0;
  bool isUploading = false;
  TextEditingController folderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: isUploading
              ? showLoading()
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: folderNameController,
                        decoration: InputDecoration(
                          labelText: 'Enter Folder Name',
                        ),
                      ),
                    ),
                    _selectedFiles == null
                        ? Text("No Images Selected")
                        : Expanded(
                            child: GridView.builder(
                              itemCount: _selectedFiles.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.file(
                                    File(_selectedFiles[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                    ElevatedButton(
                      onPressed: () {
                        uploadFunction(_selectedFiles);
                      },
                      child: Icon(Icons.file_upload),
                    )
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            selectImage();
          },
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }

  Widget showLoading() {
    return Center(
      child: Column(
        children: [
          Text("Uploading : " +
              uploadItem.toString() +
              "/" +
              _selectedFiles.length.toString()),
          SizedBox(
            height: 30,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  void uploadFunction(List<XFile> _images) {
    setState(() {
      isUploading = true;
    });
    String folderName = folderNameController.text.trim();
    for (int i = 0; i < _images.length; i++) {
      var imageURL = uploadFile(_images[i], folderName);
      _arrImageUrls.add(imageURL.toString());
    }
  }

  Future<String> uploadFile(XFile _image, String folderName) async {
    Reference reference = _storageRef
        .ref()
        .child("multiple_images")
        .child(folderName)
        .child(_image.name);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem++;
        if (uploadItem == _selectedFiles.length) {
          isUploading = false;
          uploadItem = 0;
          Get.to(FolderListPage());
        }
      });
    });
    return await reference.getDownloadURL();
  }

  Future<void> selectImage() async {
    if (_selectedFiles != null) {
      _selectedFiles.clear();
    }
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }
}

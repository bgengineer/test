import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_test/multipleImages/DetailedImagePage.dart';

class DisplayImage extends StatefulWidget {
  final String folderName;

  const DisplayImage({Key? key, required this.folderName}) : super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    try {
      // Get reference to the specified folder
      Reference reference =
          _storage.ref().child("multiple_images/${widget.folderName}");

      // List all items (images) in the folder
      ListResult result = await reference.listAll();

      // Extract download URLs of all images
      _imageUrls =
          await Future.wait(result.items.map((item) => item.getDownloadURL()));

      // Update UI
      setState(() {});
    } catch (error) {
      print("Error fetching images: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images in ${widget.folderName}'),
      ),
      body: _buildImageGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: _insertImage,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      itemCount: _imageUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FullScreenImage(imageUrls: _imageUrls, initialIndex: index),
              ),
            );
          },
          child: Image.network(
            _imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Future<void> _insertImage() async {
    try {
      final picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (var pickedFile in pickedFiles) {
          final File file = File(pickedFile.path);
          final Reference reference = _storage.ref().child(
              "multiple_images/${widget.folderName}/${file.path.split('/').last}");
          await reference.putFile(file);
        }
        _fetchImages(); // Refresh images after inserting
      }
    } catch (error) {
      print("Error inserting images: $error");
    }
  }
}

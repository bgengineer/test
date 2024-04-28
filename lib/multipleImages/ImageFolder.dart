import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_test/multipleImages/DisplayImage.dart';
import 'package:image_test/multipleImages/fileUpload.dart';

class FolderListPage extends StatefulWidget {
  const FolderListPage({Key? key}) : super(key: key);

  @override
  _FolderListPageState createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<String> _folders = [];
  Map<String, String> _folderImages = {};

  @override
  void initState() {
    super.initState();
    _fetchFolders();
  }

  Future<void> _fetchFolders() async {
    try {
      // Get reference to the "multiple_images" folder
      Reference reference = _storage.ref().child("multiple_images");

      // List all items (folders and files) in the "multiple_images" folder
      ListResult result = await reference.listAll();

      // Extract only the folder names
      _folders = result.prefixes.map((folder) => folder.name).toList();

      // Get the first image of each folder and store their download URLs
      for (String folderName in _folders) {
        ListResult folderResult = await reference.child(folderName).listAll();
        if (folderResult.items.isNotEmpty) {
          String firstImageURL =
              await folderResult.items.first.getDownloadURL();
          _folderImages[folderName] = firstImageURL;
        }
      }

      // Update UI
      setState(() {});
    } catch (error) {
      print("Error fetching folders: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders Images'),
      ),
      body: _buildFolderGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(FileUpload());
        },
        child: Icon(Icons.add_a_photo_sharp),
      ),
    );
  }

  Widget _buildFolderGrid() {
    return GridView.builder(
      itemCount: _folders.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0, // Ensure square-shaped cards
      ),
      itemBuilder: (context, index) {
        String folderName = _folders[index];
        String? backgroundImageURL = _folderImages[folderName];
        return GestureDetector(
          onTap: () {
            // Navigate to a page to display images inside the selected folder
            Get.to(DisplayImage(folderName: _folders[index]));
          },
          child: Card(
            elevation: 3.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (backgroundImageURL != null)
                  // Apply translucent overlay to the image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(backgroundImageURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black
                          .withOpacity(0.3), // Adjust opacity as needed
                    ),
                  ),
                Center(
                  child: Text(
                    folderName,
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

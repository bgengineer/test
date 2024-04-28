import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_test/singleImages/CommunityAddpage.dart';
import 'package:image_test/singleImages/CommunityDetailPage.dart';

class CommunityViewPage extends StatefulWidget {
  const CommunityViewPage({Key? key}) : super(key: key);

  @override
  _CommunityViewPageState createState() => _CommunityViewPageState();
}

class _CommunityViewPageState extends State<CommunityViewPage> {
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  late List<Reference> _imageReferences = [];
  late List<String> _imageUrls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    ListResult result = await _storageRef.ref().child("community").listAll();
    List<Future<String>> downloadUrls =
        result.items.map((ref) => ref.getDownloadURL()).toList();
    List<String> urls = await Future.wait(downloadUrls);
    setState(() {
      _imageReferences = result.items;
      _imageUrls = urls;
      _isLoading = false; // Set loading to false after images are loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Images'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _imageReferences.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityDetailsPage(
                          imageUrl: _imageUrls[index],
                          imageName: _imageReferences[index].name,
                          position:
                              "Position Value Here", // Replace with actual position
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          _imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _imageReferences[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CommunityAddPage());
        },
        child: Icon(Icons.person_add),
      ),
    );
  }
}

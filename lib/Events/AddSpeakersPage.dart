import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddCommunityViewPage extends StatefulWidget {
  @override
  _AddCommunityViewPageState createState() => _AddCommunityViewPageState();
}

class _AddCommunityViewPageState extends State<AddCommunityViewPage> {
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  late List<Reference> _imageReferences = [];
  late List<String> _imageUrls = [];
  List<String> _selectedSpeakers = [];
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
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Speakers'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, _selectedSpeakers);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _imageReferences.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_imageReferences[index].name),
                  leading: Checkbox(
                    value: _selectedSpeakers.contains(_imageReferences[index].name),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          _selectedSpeakers.add(_imageReferences[index].name);
                        } else {
                          _selectedSpeakers.remove(_imageReferences[index].name);
                        }
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

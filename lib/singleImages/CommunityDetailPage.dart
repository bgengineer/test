import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String imageName;
  final String position;

  const CommunityDetailsPage({
    required this.imageUrl,
    required this.imageName,
    required this.position,
    Key? key,
  }) : super(key: key);

  @override
  _CommunityDetailsPageState createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends State<CommunityDetailsPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _position;

  @override
  void initState() {
    super.initState();
    _position = widget.position;
    fetchPosition();
  }

  Future<void> fetchPosition() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('community')
          .where('imageName', isEqualTo: widget.imageName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _position = querySnapshot.docs.first.get('position');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCommunityMember() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('community')
          .where('imageName', isEqualTo: widget.imageName)
          .get();

      print('Image Name to delete: ${widget.imageName}');
      print(
          'Documents found: ${querySnapshot.docs.map((doc) => doc.id).toList()}');

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        Navigator.pop(
            context); // Navigate back to the previous screen after deletion
      } else {
        print('Document not found');
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Image Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  widget.imageUrl,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name: ${widget.imageName}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Position: $_position',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    deleteCommunityMember();
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_test/Events/EventAddPage.dart';
import 'EventDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Vconverge').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                elevation: 4, // Add elevation for a card-like effect
                margin: EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16), // Adjust margins
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12), // Round the corners of the card
                ),
                child: ListTile(
                  leading:
                      Icon(Icons.event), // Add event icon as leading widget
                  title: Text(
                    event['name'] ?? 'No Event Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    event['date'],
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(event: event),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(VconvergeAddPage());
        },
        child: Icon(Icons.event),
      ),
    );
  }
}

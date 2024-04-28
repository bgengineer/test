import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event,
                  size: 38,
                ),
                SizedBox(width: 5),
                Text(
                  '${event['name']}',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.date_range),
                SizedBox(width: 5),
                Text(
                  '${event['date']}',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(), // Added Spacer widget to push the time to the right
                Icon(Icons.timelapse),
                Text(
                  '${event['startTime']} - ${event['endTime']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Icon(Icons.group),
                SizedBox(width: 5),
                Text(
                  'Speakers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var speaker in event['speakers'])
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Text(
                            '• $speaker',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.description),
                SizedBox(width: 5),
                Text(
                  'Description:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${event['description']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(
                  '${event['location']}',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                    onPressed: () {
                      _launchMapsUrl('${event['location']}');
                    },
                    child: Text("Navigate"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchMapsUrl(String location) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_test/Events/AddEventFunctions.dart';
import 'package:image_test/Events/AddSpeakersPage.dart';
import 'package:image_test/Events/EventsViewPage.dart';

class VconvergeAddPage extends StatefulWidget {
  @override
  _VconvergeAddPageState createState() => _VconvergeAddPageState();
}

class _VconvergeAddPageState extends State<VconvergeAddPage> {
  EventAddFunctions _eventAddFunctions = EventAddFunctions(
      dateController: TextEditingController(),
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
      descriptionController: TextEditingController(),
      locationController: TextEditingController(),
      eventNameController: TextEditingController() // Add this line

      );

  Future<void> _addEventToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('Vconverge').add({
        'name': _eventAddFunctions.eventNameController.text,
        'date':
            _eventAddFunctions.selectedDate!.toLocal().toString().split(' ')[0],
        'startTime': _eventAddFunctions.selectedStartTime!.format(context),
        'endTime': _eventAddFunctions.selectedEndTime!.format(context),
        'speakers': _eventAddFunctions.selectedSpeakers,
        'description': _eventAddFunctions.descriptionController.text,
        'location': _eventAddFunctions.locationController.text,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event added successfully')),
      );

      // Clear form fields
      _eventAddFunctions.dateController.clear();
      _eventAddFunctions.eventNameController.clear();
      _eventAddFunctions.startTimeController.clear();
      _eventAddFunctions.endTimeController.clear();
      _eventAddFunctions.descriptionController.clear();
      _eventAddFunctions.locationController.clear();
      _eventAddFunctions.selectedSpeakers.clear();
      _eventAddFunctions.selectedDate = null;
      _eventAddFunctions.selectedStartTime = null;
      _eventAddFunctions.selectedEndTime = null;

      Get.to(EventsPage());
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _eventAddFunctions.eventNameController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                prefixIcon: Icon(Icons.event),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _eventAddFunctions.dateController,
              readOnly: true,
              onTap: () => _eventAddFunctions.selectDate(context),
              decoration: InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _eventAddFunctions.startTimeController,
                    readOnly: true,
                    onTap: () => _eventAddFunctions.selectStartTime(context),
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      prefixIcon: Icon(Icons.access_time_rounded),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: TextField(
                    controller: _eventAddFunctions.endTimeController,
                    readOnly: true,
                    onTap: () => _eventAddFunctions.selectEndTime(context),
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      prefixIcon: Icon(Icons.access_time_rounded),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _eventAddFunctions.selectedSpeakers.isNotEmpty
                        ? _eventAddFunctions.selectedSpeakers[0]
                        : null,
                    items: _eventAddFunctions.getSpeakerItems(),
                    onChanged: (newValue) {
                      setState(() {
                        _eventAddFunctions.selectedSpeakers[0] = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Speakers',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _eventAddFunctions.addSpeaker(context),
                  icon: Icon(Icons.person_add),
                  tooltip: 'Add Speaker',
                ),
              ],
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _eventAddFunctions.descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _eventAddFunctions.locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addEventToFirebase();
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}

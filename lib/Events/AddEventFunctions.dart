import 'package:flutter/material.dart';
import 'package:image_test/Events/AddSpeakersPage.dart';

class EventAddFunctions {
  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final TextEditingController eventNameController;

  List<String> selectedSpeakers = [];
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  EventAddFunctions({
    required this.dateController,
    required this.startTimeController,
    required this.endTimeController,
    required this.descriptionController,
    required this.locationController,
    required this.eventNameController,
  });

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate)
      selectedDate = pickedDate;
    dateController.text = pickedDate!.toLocal().toString().split(' ')[0];
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(),
    );

    if (pickedStartTime != null && pickedStartTime != selectedStartTime)
      selectedStartTime = pickedStartTime;
    startTimeController.text = pickedStartTime!.format(context);
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? TimeOfDay.now(),
    );

    if (pickedEndTime != null && pickedEndTime != selectedEndTime)
      selectedEndTime = pickedEndTime;
    endTimeController.text = pickedEndTime!.format(context);
  }

  Future<void> addSpeaker(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCommunityViewPage(),
      ),
    );

    if (result != null) {
      selectedSpeakers = List.from(result);
    }
  }

  List<DropdownMenuItem<String>> getSpeakerItems() {
    return selectedSpeakers.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }
}

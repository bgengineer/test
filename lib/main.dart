import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:image_test/Events/EventAddPage.dart';
import 'package:image_test/Events/EventsViewPage.dart';
import 'package:image_test/multipleImages/DisplayImage.dart';
import 'package:image_test/multipleImages/ImageFolder.dart';
import 'package:image_test/multipleImages/fileUpload.dart';
import 'package:image_test/singleImages/CommunityAddpage.dart';
import 'package:image_test/singleImages/CommunityViewPage.dart';
import 'package:image_test/utils.dart';

void main() async {
  await setUp();
  runApp(const MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpFirebase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: EventsPage());
  }
}

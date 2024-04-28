import 'package:firebase_core/firebase_core.dart';
import 'package:image_test/firebase_options.dart';

Future<void> setUpFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

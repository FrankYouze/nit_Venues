import 'package:nit_avros/firebase_options.dart';
import 'package:nit_avros/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nit_avros/pages/home_page.dart';
import 'package:nit_avros/pages/somepage.dart';
import 'package:nit_avros/pages/venue_data.dart';

void main() async {

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,

);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VenueData(),
     
    );
  }
}



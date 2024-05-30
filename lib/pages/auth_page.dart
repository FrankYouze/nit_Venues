import 'package:nit_avros/pages/home_page.dart';
import 'package:nit_avros/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nit_avros/pages/some_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 body: StreamBuilder<User?> (
stream: FirebaseAuth.instance.authStateChanges(),
builder: (context,snapshot){

if(snapshot.hasData){

  return SomePage();
}else{

  return LoginPage();
}

},

 ),


    );
  }
}
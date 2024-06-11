import 'package:nit_avros/components/my_button.dart';
import 'package:nit_avros/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

    final userEmailcon = TextEditingController();
    final passcon = TextEditingController();


void signInUser()async{
  

await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: userEmailcon.text,
   password: passcon.text);
  
}
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                      color: Color.fromARGB(255, 44, 43, 43), fontSize: 22),
                ),
                SizedBox(height: 30,),
             

                 //SizedBox(height: 10,),
                MyTextField(
                  myText: "enter user email",
                  obscu: false,
                  controller: userEmailcon,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  myText: "enter password",
                  obscu: true,
                  controller: passcon,
                ),
                const SizedBox(height: 20,),
                 MyButton(onTap: signInUser ,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
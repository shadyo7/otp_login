import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_login/login_Screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen',
          style:TextStyle(
            color: Colors.white,
          ) ,),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10),
          child: Image.asset('images/welcome.jpg'),
          ),

          Container(
            margin: EdgeInsets.only(top: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: (){
                 FirebaseAuth.instance.signOut();
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              child: Text('Logout',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
          )

        ],
      ),
    );
  }
}

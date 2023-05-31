// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_login/welcomeScreen.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPControllerScreen extends StatefulWidget {

  final String phone;
  final String phoneCode;

  OTPControllerScreen({required this.phone,required this.phoneCode});

  @override
  State<OTPControllerScreen> createState() => _OTPControllerScreenState();
}

class _OTPControllerScreenState extends State<OTPControllerScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey =GlobalKey<ScaffoldState>();
  final TextEditingController _pinOtpController = TextEditingController();
  final FocusNode _pinOTPFocus = FocusNode();
  String? verificationCode;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
         color: Colors.blueAccent,
         borderRadius: BorderRadius.circular(10),
         border: Border.all(
           color: Colors.grey,
         )
  );

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async{
       await FirebaseAuth.instance.verifyPhoneNumber(
           phoneNumber: widget.phoneCode + widget.phone,
           verificationCompleted: (PhoneAuthCredential credential) async{
             await FirebaseAuth.instance.signInWithCredential(credential).then((value){
               if(value.user != null){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WelcomeScreen()));
               }
             }
             );
           },
           verificationFailed: (FirebaseAuthException e){
             ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Invalid OTP'),
                   duration: Duration(seconds: 3),
                 )
             );
           },

           codeSent: (String vID, int? resentToken){
               setState(() {
                 verificationCode=vID;
               });
           },

         codeAutoRetrievalTimeout: (String vID){
             setState(() {
               verificationCode=vID;
             });
         },
         timeout: Duration(seconds: 60),
       );
       }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(20),
          child: Image.asset('images/otp.png'),
          ),
         Container(
           margin: EdgeInsets.only(top: 20),
           child: Center(
             child: GestureDetector(
               onTap: (){
                 verifyPhoneNumber();
               },
               child: Text('Verifying ${widget.phoneCode}-${widget.phone}',
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 20,
               ),
               ),
             ),
           ),
         ),
         Padding(
           padding: EdgeInsets.all(30),
           child: PinPut(
             fieldsCount: 6,
             eachFieldWidth: 44,
             eachFieldHeight: 55,
             textStyle: TextStyle(fontSize: 20,color: Colors.white),
             focusNode: _pinOTPFocus,
             controller: _pinOtpController,
             submittedFieldDecoration: pinOTPCodeDecoration,
             selectedFieldDecoration: pinOTPCodeDecoration,
             followingFieldDecoration: pinOTPCodeDecoration,
             pinAnimationType: PinAnimationType.rotation,
             onSubmit: (pin) async{
               try{
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider
                      .credential(verificationId: verificationCode!, smsCode:pin)).then((value){
                        if(value.user != null){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WelcomeScreen()));
                        }
                  }
                  );
               }
               catch(e){
                 FocusScope.of(context).unfocus();
                 ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                     content: Text('Invalid OTP'),
                     duration: Duration(seconds: 3),
                   )
                 );
               }
             },
           ),
         ),
        ],
      ),
    );
  }
}

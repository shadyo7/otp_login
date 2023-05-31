// ignore_for_file: prefer_const_constructors

import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:otp_login/OTPcontroller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String countryDialCode='';
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:const EdgeInsets.all(30),
                  child: Image.asset('images/login.jpg'),
                ),
                Container(
                  margin:const EdgeInsets.only(top: 10),
                  child: const Center(
                    child: Text(
                      'Phone (OTP) Authentication',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 60,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CountryPickerDropdown(
                        initialValue: 'Pk',
                        onValuePicked: (Country country) {
                          setState(() {
                            countryDialCode=country.phoneCode;
                          });
                      },
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration:InputDecoration(
                      hintText: 'Phone Number',
                      prefix: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(countryDialCode),
                      ),
                    ),
                    maxLength: 12,
                    keyboardType: TextInputType.number,
                    controller:_controller,
                  ),
                ),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OTPControllerScreen(
                    phone:_controller.text,
                    phoneCode:countryDialCode,
                  )));
                },
                    child: Text('Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),))
              ],
            ),
      ),
    );
  }
}

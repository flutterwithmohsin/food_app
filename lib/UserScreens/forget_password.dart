import 'package:flutter/gestures.dart';
import'package:flutter/material.dart';
import 'package:food_app/UserScreens/login.dart';
import 'package:food_app/UserScreens/sign_up.dart';
import 'package:get/get.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController userEmail =TextEditingController();
  final ForgerPasswordController forgerPasswordController =Get.put(ForgerPasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 80,),
          Center(
            child: Text('Password Recovery',
            style: TextStyle(fontSize: 25,
              fontFamily: 'Poppins',
              color: Colors.white
             ),),
          ),
          SizedBox(height: 20,),
          Center(
            child: Text('Enter your mail',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Colors.white
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 38),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: userEmail,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.person,color: Colors.grey,),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 42,left: 20,right: 20),
            child: GestureDetector(
              onTap: ()async{
                print('tapedd--------');
                String email=userEmail.text.trim();
                if(email.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent,content: Text('Please enter valid email',style: TextStyle(color: Colors.white),)));
                }else{
                  await forgerPasswordController.ForgetPasswordMethod(email);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LogIn()));
                }
              },
              child: Container(
                padding: EdgeInsets.all(13),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('Send Email',style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.black
                  ),),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
            },
            child: Center(
              child: RichText(text: TextSpan(text: "Don't have an account?",style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontFamily: 'Poppins'
              ),
                children: [
                  TextSpan(
                      text: 'Create',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 184, 166, 6),
                      fontFamily: 'Poppins'
                  ))
                ]
              ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

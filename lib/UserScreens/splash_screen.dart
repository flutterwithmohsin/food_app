import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/UserScreens/login.dart';
import 'package:food_app/UserScreens/on_boarding_screen.dart';
import 'package:food_app/admin/admin_home.dart';
import 'package:food_app/bottom_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../controllers/get_user_data_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user =FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   Timer(Duration(seconds: 3),(){
     loggedIn(context);
   });
  }

  Future<void>loggedIn(BuildContext context)async {
    if(user!=null){
      final GetUserDataController getUserDataController=Get.put(GetUserDataController());
      var userData= await getUserDataController.getUserData(user!.uid);
      if(userData[0]['isAdmin']==true){
        Get.offAll(()=>AdminHome());
      }else{
        Get.offAll(()=>BottomBar());
      }
    }else{
      Get.offAll(()=>OnBoardingScreen());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color:Colors.orangeAccent,
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Center(child: Lottie.asset('images/foodie.json',width: MediaQuery.of(context).size.width/1.5,),)),
              Expanded(child: Center(child: Lottie.asset('images/burger.json',
                width: MediaQuery.of(context).size.width/1.5,),)),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Center(child: Text('Powered By Love',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Colors.white
                ),),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

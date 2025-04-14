import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/UserScreens/login.dart';
import 'package:food_app/admin/add_food_item.dart';
import 'package:food_app/admin/admin_order_screen.dart';
import 'package:food_app/admin/notify.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'admin_sales_analytics.dart';
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String ? id=FirebaseAuth.instance.currentUser!.uid;
  bool logout=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child:Column(
            children: [
              Material(
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.only(top: 30),
                  child: Center(child: Lottie.asset('images/foodie.json',
                      height: 70,width: MediaQuery.of(context).size.width/1.5),),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>AddFoodItem()));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 12,top: 13,bottom: 13),
                  margin: EdgeInsets.only(left: 15,right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black
                  ),
                  child: Row(children: [
                    Lottie.asset('images/add_food.json',height: 70,width: 80),
                    // Image.asset('images/food.jpg',height: 80,width: 80,fit: BoxFit.cover,),
                    SizedBox(width: 20,),
                    Text('Add Food Items',style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),)
                  ],),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminOrdersScreen()));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 12,top: 13,bottom: 13),
                  margin: EdgeInsets.only(left: 15,right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black
                  ),
                  child: Row(children: [
                    Lottie.asset('images/o.json',height: 70,width: 95),
                    // Image.asset('images/food.jpg',height: 80,width: 80,fit: BoxFit.cover,),
                    SizedBox(width: 20,),
                    Text('Order',style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),)
                  ],),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Get.to(()=>Notify());
                },
                child: Container(
                  padding: EdgeInsets.only(left: 12,top: 13,bottom: 13),
                  margin: EdgeInsets.only(left: 15,right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black
                  ),
                  child: Row(children: [
                    Lottie.asset('images/b.json',height: 70,width: 80),
                    // Image.asset('images/food.jpg',height: 80,width: 80,fit: BoxFit.cover,),
                    SizedBox(width: 20,),
                    Text('Notify Users',style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),)
                  ],),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Get.to(()=>AdminSalesAnalytics());
                },
                child: Container(
                  padding: EdgeInsets.only(left: 12,top: 13,bottom: 13),
                  margin: EdgeInsets.only(left: 15,right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black
                  ),
                  child: Row(children: [
                    Lottie.asset('images/sales.json',height: 60,width: 70),
                    // Image.asset('images/food.jpg',height: 80,width: 80,fit: BoxFit.cover,),
                    SizedBox(width: 20,),
                    Text('Sales',style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),)
                  ],),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
               onTap: ()async{
                 setState(() {
                   logout=true;
                 });
                 await FirebaseAuth.instance.signOut();
                 GoogleSignIn googleSignIn=GoogleSignIn();
                 await googleSignIn.signOut();
                 await FirebaseFirestore.instance.collection('Users').doc(id).update({
                   'isActive' : false
                 });
                 Get.offAll(()=>LogIn());
               },
                child: Container(
                  padding: EdgeInsets.only(left: 12,top: 13,bottom: 13),
                  margin: EdgeInsets.only(left: 15,right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black
                  ),
                  child: Row(children: [
                    Lottie.asset('images/l.json',height: 70,width: 90),
                    // Image.asset('images/food.jpg',height: 80,width: 80,fit: BoxFit.cover,),
                    SizedBox(width: 20,),
                    logout?Text('Logging Out',style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),):
                    Text('Logout',style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),)
                  ],),
                ),
              ),

            ],
          ),
        ),
      )
    );
  }
}

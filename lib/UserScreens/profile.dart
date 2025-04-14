import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/UserScreens/login.dart';
import 'package:food_app/UserScreens/order_history.dart';
import 'package:food_app/UserScreens/sign_up.dart';
import 'package:food_app/admin/admin_order_screen.dart';
import 'package:food_app/textwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName='';
  bool ab=false;
  String userEmail='';
  String? id=FirebaseAuth.instance.currentUser!.uid;
  Future<void>getUserdata()async{
    DocumentSnapshot ds=await FirebaseFirestore.instance.collection('Users').doc(id).get();
     userName = ds['username']; // Assuming ds is a Map or similar
     userEmail = ds['email']; // Assuming ds is a Map or similar
    // firstName = userName.split(' ')[0]; // Split by space and take the first word
    print(userName+'----'+userEmail);
    setState(() {});// This will print "Muhammad"
  }
//   ontherload(){
//
// }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  getUserdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  // margin: EdgeInsets.only(top: ),
                  height: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(MediaQuery.of(context).size.width, 150.0)
                    )
                  ),
                ),
                Center(
                  child: Container(
                    margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/7.2) ,
                    child: Material(
                     elevation: 5,
                      borderRadius: BorderRadius.circular(72.5),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(72.5),
                          child: Image.asset('images/1.jpeg',height: 145,width: 145,fit: BoxFit.cover,)),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.person,size: 25,),
                      SizedBox(width: 20,),
                      Column(
    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name', style: textWidget.semiTextStyle(),),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/2.2,
                              child: Text(userName,style: textWidget.lightTextStyle(),overflow: TextOverflow.ellipsis,)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.email,size: 25,),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email', style: textWidget.semiTextStyle(),),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/2.2,
                              child: Text(userEmail,style: textWidget.lightTextStyle(),overflow: TextOverflow.ellipsis,)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderHistory()));
             },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.description,size: 25,),
                        SizedBox(width: 20,),
                        SizedBox(
                          child: Text('Orders', style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: ()async{
                setState(() {
                   ab=true;
                });
                await   FirebaseAuth.instance.signOut();
                 GoogleSignIn googleSignIn =GoogleSignIn();
                 await googleSignIn.signOut();
                await FirebaseFirestore.instance.collection('Users').doc(id).update({
                  'isActive' : false
                });
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogIn()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.logout,size: 25,),
                        SizedBox(width: 20,),
                        SizedBox(
                          child: ab?Text('Logging Out',style:TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ), )
                          :Text('Logout', style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

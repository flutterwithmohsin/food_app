import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/UserScreens/home_screen.dart';
import 'package:food_app/UserScreens/login.dart';
import 'package:food_app/controllers/sign_up_controller.dart';
import 'package:food_app/textwidget.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../bottom_bar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var isPasswordVisible = true.obs;

  final TextEditingController userName = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  final TextEditingController userEmail = TextEditingController();
  SignUpController signUpController=Get.put(SignUpController());
  String password = "";
  String name = "";
  String email = "";
  bool isLoading=false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userName.dispose();
    userEmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  Future<void> registration() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Check if user already exists in Firestore
        final String? userId = userCredential.user?.uid;
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        if (!userDoc.exists) {
          // User doesn't exist; add to Firestore
          await adduser();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Registered Successfully',
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomBar()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Account already exists',
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Password is too weak',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Account already exists',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'An error occurred. Please try again.',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  Future<void> adduser() async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('Users').doc(userId).set({
      'name': userName.text.trim(),
      'password': userPassword.text.trim(),
      'email': userEmail.text.trim(),
      'wallet':0,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Gradient background
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffff5c30),
                      Color(0xffe74b1a),
                    ],
                  ),
                ),
              ),
              // White bottom container
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
              ),
              // Logo
              Container(
                margin: EdgeInsets.only(top: 85, left: 20, right: 20),
                child: Image.asset('images/logo.png', fit: BoxFit.fill),
              ),
              // Form Container
              Container(
                margin: EdgeInsets.only(
                  top: 180,
                  bottom: 145,
                  left: 20,
                  right: 20,
                ),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Sign Up',
                              style: textWidget.headlineTextStyle(),
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500),
                              controller: userName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outlined),
                                hintText: 'Name',
                                hintStyle: textWidget.semiTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: TextFormField(
                              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500),
                              controller: userEmail,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: 'Email',
                                hintStyle: textWidget.semiTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Obx(
                                  () => TextFormField(
                                    style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500),
                                controller: userPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Password';
                                  }
                                  return null;
                                },
                                obscureText: isPasswordVisible.value,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      isPasswordVisible.toggle();
                                    },
                                    child: Icon(isPasswordVisible.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: textWidget.semiTextStyle(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: ()async {
                              setState(() {
                                isLoading=true;
                              });
                              if (_formKey.currentState!.validate()) {
                                email = userEmail.text.trim();
                                name = userName.text.trim();
                                password = userPassword.text.trim();
                              UserCredential? userCredential=await
                              signUpController.signUpMethod(name, email, password);
                                if (userCredential != null) {
                                 setState(() {
                                   isLoading=false;
                                 });
                                  Get.snackbar(
                                      'Verfication Email Sent', 'Check your Inbox',
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Colors.white,
                                      backgroundColor: Colors.orangeAccent);
                                  FirebaseAuth.instance.signOut();
                                  Get.to(() => LogIn());
                                }else{
                                  setState(() {
                                    isLoading=false;
                                  });
                                }
                              }else{
                                setState(() {
                                  isLoading=false;
                                });
                              }
                            },
                            child: isLoading?
                            Center(
                                child: Lottie.asset('images/loader.json',height: 50,width: 50)
                            ):Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 200,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xffff5729),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Login Link
              Positioned(
                top: MediaQuery.of(context).size.height - 90,
                left: MediaQuery.of(context).size.width / 10,
                right: MediaQuery.of(context).size.width / 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Already have an account? Login",
                      style: textWidget.semiTextStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/UserScreens/forget_password.dart';
import 'package:food_app/UserScreens/sign_up.dart';
import 'package:food_app/admin/admin_home.dart';
import 'package:food_app/bottom_bar.dart';
import 'package:food_app/controllers/get_user_data_controller.dart';
import 'package:food_app/controllers/google_sign_in_controller.dart';
import 'package:food_app/controllers/login_controller.dart';
import 'package:food_app/textwidget.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var isPasswordVisible=true.obs;
  LoginController loginController=Get.put(LoginController());
  GetUserDataController getUserDataController=Get.put(GetUserDataController());
  TextEditingController userEmail =TextEditingController();
  TextEditingController userPassword =TextEditingController();
final  GoogleSignInController googleSignInController=Get.put(GoogleSignInController());
  bool tap=false;
  bool gLoading=false;
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/2.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color(0xffff5c30),
                      Color(0xffe74b1a),
                    ])
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight:Radius.circular(40),topLeft: Radius.circular(40)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 85,left: 20,right: 20),
                  child: Image.asset('images/logo.png',fit: BoxFit.fill,),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  margin: EdgeInsets.only(top: 180,bottom: 60,left: 20,right: 20),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: MediaQuery.of(context).size.height/1.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Center(child: Text('Login',style:textWidget.headlineTextStyle())),
                          SizedBox(height: 30,)
                          ,Padding(
                            padding: const EdgeInsets.only(left: 15,right: 15),
                            child: TextFormField(
                              controller: userEmail,
                              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500),
                             decoration: InputDecoration(
                               prefixIcon: Icon(Icons.email_outlined),
                               hintText: 'Email',
                               hintStyle: textWidget.semiTextStyle()
                             ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15,right: 15,top: 35),
                            child: Obx(()=>TextFormField(
                              controller: userPassword,
                              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500),
                              obscureText: isPasswordVisible.value,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.password_outlined),
                                  suffixIcon: GestureDetector(
                                      onTap: (){
                                        isPasswordVisible.toggle();
                                      },
                                      child:
                                      isPasswordVisible.value?
                                      Icon(Icons.visibility_off_outlined):Icon(Icons.visibility_outlined)
                                  ),
                                  hintText: 'Password',
                                  hintStyle: textWidget.semiTextStyle()
                              ),
                            ),)
                          ),
                          SizedBox(height: 24,),
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassword()));
                                },
                                child: Text('Forgot Password?',style: textWidget.semiTextStyle(),)),
                          ),
                          SizedBox(height: 50,),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true; // Show loader when tapped
                          });

                          String email = userEmail.text.trim();
                          String password = userPassword.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            setState(() {
                              isLoading = false; // Hide loader
                            });

                            Get.snackbar("Error", "Please fill in all fields",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white);
                          } else {
                            UserCredential? userCredential =
                            await loginController.logInMethod(email, password);

                            if (userCredential != null && userCredential.user!.emailVerified) {

                              var userdata =
                              await getUserDataController.getUserData(userCredential.user!.uid);

                              if (userdata[0]['isAdmin'] == true) {
                                setState(() {
                                  isLoading = false; // Hide loader before navigation
                                });
                                Get.offAll(() => AdminHome());
                              } else {
                                setState(() {
                                  isLoading = false; // Hide loader before navigation
                                });

                                Get.snackbar('Success', 'Login Successfully',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.orangeAccent,
                                    colorText: Colors.white);
                                Get.offAll(() => BottomBar());
                              }
                            } else {
                              setState(() {
                                isLoading = false; // Hide loader
                              });

                              Get.snackbar('Email not verified', 'Check your inbox',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white);
                            }
                          }
                        },
                        child:isLoading?
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: Lottie.asset('images/loader.json',height: 50,width: 50)
                            ),
                        )
                          :Container(
                          margin: EdgeInsets.only(bottom: 25),
                            child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Color(0xffff5729),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:  Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins'),
                                ),
                              )
                            ),
                                                    ),
                          ),
                      )
                        //
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
              },
              child: Center(
                child: Container(
                    alignment: Alignment.center,
                    child: Text("Don't have an account?Sign up",style: textWidget.semiTextStyle(),)),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: ()async{
                setState(() {
                  gLoading=true;
                });
                print('-------------------------');
               await googleSignInController.signInWithGoogle();
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                        ,border:Border.all(color: Colors.black,width: 1.5)
                  ),
                  margin: EdgeInsets.only(bottom: 35),
                  child:gLoading?Container(
                      height: 40,
                      width: 40,
                      child: Center(child: CircularProgressIndicator(color: Colors.orangeAccent,),))
                  :Image.asset('images/download.png',height: 40,width: 40,fit:BoxFit.cover),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

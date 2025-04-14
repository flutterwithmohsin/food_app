
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app/bottom_bar.dart';
import 'package:food_app/controllers/get_user_data_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../admin/admin_home.dart';
import '../models/user_model.dart';
import 'device_token_controller.dart';


class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetUserDataController getUserDataController=Get.put(GetUserDataController());

  Future<void> signInWithGoogle() async {
    print('object------------calleddddddddddddddddddddddd');
    final GetDeviceTokenController getDeviceTokenController =
    Get.put(GetDeviceTokenController());
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        EasyLoading.showToast('Please Wait');
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          final userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);

          final DocumentSnapshot userDoc = await userDocRef.get();

          if (userDoc.exists) {
            // Update existing fields
            await userDocRef.update({
              'userDeviceToken': getDeviceTokenController.deviceToken.toString(),
              'isActive': true, // Update only specific fields
            });
          } else {
            // Create new user document
            UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              userDeviceToken: getDeviceTokenController.deviceToken.toString(),
              country: '',
              userAddress: '',
              street: '',
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now(),
              city: '',
              wallet: 0,
            );
            print(getDeviceTokenController.deviceToken.toString()+'-----------------');
            await userDocRef.set(userModel.toMap());
          }
          var userdata =
          await getUserDataController.getUserData(userCredential.user!.uid);

          if (userdata[0]['isAdmin'] == true) {
            EasyLoading.dismiss();
            Get.offAll(() => AdminHome());
          } else {
             EasyLoading.dismiss();
            Get.snackbar('Success', 'Login Successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orangeAccent,
                colorText: Colors.white);
            Get.offAll(() => BottomBar());
          }
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("error $e");
    }
  }
}

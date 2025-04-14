// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import 'device_token_controller.dart';
import 'package:flutter/material.dart';


class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetDeviceTokenController getDeviceTokenController=Get.put(GetDeviceTokenController());

  //for password visibilty
  var isPasswordVisible = true.obs;

  Future<UserCredential?> signUpMethod(
      String userName,
      String userEmail,
      String userPassword,
      ) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // send email verification
      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        phone:'',
        userImg: '',
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

      // add data into database
      _firestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}

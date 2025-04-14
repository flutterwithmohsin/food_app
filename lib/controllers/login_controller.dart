// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //for password visibilty
  var isPasswordVisible = true.obs;

  Future<UserCredential?> logInMethod(
      String userEmail, String userPassword) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {


      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Please try again.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format. Please enter a valid email.";
          break;
        case 'user-disabled':
          errorMessage = "This account has been disabled. Contact support.";
          break;
        case 'too-many-requests':
          errorMessage =
          "Too many login attempts. Please try again later.";
          break;
        case 'network-request-failed':
          errorMessage = "Network error. Check your internet connection.";
          break;
        default:
          errorMessage =
          "An unexpected error occurred. Please try again later.";
      }

      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }

  }
}

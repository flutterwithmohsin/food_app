import 'package:flutter/material.dart';

class textWidget{
  static TextStyle boldTextStyle(){
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'Poppins',
    );
}

  static TextStyle headlineTextStyle(){
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.black,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle lightTextStyle(){
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Colors.black38,
      fontFamily: 'Poppins',
    );
  }
  static TextStyle semiTextStyle(){
    return TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 16.5,
      color: Colors.black,
      fontFamily: 'Poppins',
    );
  }
  static TextStyle priceTextStyle(){
    return TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 18,
      color: Colors.black,
      fontFamily: 'Poppins',
    );
  }

}
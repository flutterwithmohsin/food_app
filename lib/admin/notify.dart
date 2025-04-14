import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Notify extends StatelessWidget {
  const Notify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
            Container(
              margin: EdgeInsets.only(top: 95,left: 3,right: 3),
              child: Center(
                child: Lottie.asset('images/u.json'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

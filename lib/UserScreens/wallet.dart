import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_app/payment_service.dart';
import 'package:food_app/textwidget.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final String userId= FirebaseAuth.instance.currentUser!.uid;
  final  userEmail= FirebaseAuth.instance.currentUser!.email;
  bool a=false,b=false,c=false,d=false;
  int amount=0;
  String walletvalue='';
  Map<String,dynamic>? paymentIntent={};
  Future<void>getWallet()async{
    DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if(snapshot.exists){
     setState(() {
       walletvalue=snapshot['wallet'].toString();
       print('Value of wallet is'+walletvalue+'of'+userEmail.toString());
     });
      // walletvalue=wallet;
    }else{
      print('------No Wallet-------');
    }
  }
  reload(){
    Timer(Duration(seconds: 2),(){
      setState(() {});
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWallet();
  }

  PaymentService paymentService=PaymentService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream:FirebaseFirestore.instance.collection('Users').doc(userId).snapshots() ,
          builder: (context,snapshot){
         return Container(
           child: Column(
             children: [
               Material(
                 elevation: 2,
                 child: Container(
                   margin: EdgeInsets.only(top: 50),
                   padding: EdgeInsets.only(bottom: 10),
                   child: Center(
                     child: Text('Wallet',style:TextStyle(
                         fontSize: 22,
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w800,
                         color: Colors.black
                     ),),
                   ),
                 ),
               ),
               SizedBox(height: 30,),
               // Wallet Container
               Container(
                   padding: EdgeInsets.all(5),
                   width: MediaQuery.of(context).size.width,
                   color: Color(0xfff2f2f2),
                   child: Padding(
                     padding: const EdgeInsets.only(left: 10),
                     child: Row(
                       children: [
                         Image.asset('images/wallet.png',height: 60,width: 50,fit: BoxFit.fill,)
                         ,SizedBox(width: 45,),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Your Wallet',style: textWidget.lightTextStyle(),),
                             Text('\$'+walletvalue, style: textWidget.priceTextStyle(),),
                           ],
                         )
                       ],
                     ),
                   )
               ),
               SizedBox(height: 25,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   GestureDetector(
                     onTap: (){
                       amount=100;
                       a=true;
                       b=false;
                       c=false;
                       d=false;
                       setState(() {});
                     },
                     child: Container(
                       padding: EdgeInsets.only(top: 4,bottom: 4,left: 10,right: 10),
                       decoration: BoxDecoration(
                           color: a?Colors.black:Colors.white,
                           border: Border.all(width: 1.4,color: a?Colors.white:Colors.black),
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: Center(child: Text('\$'+'100',style: TextStyle(
                         fontWeight: FontWeight.w800,
                         fontSize: 18,
                         color:a?Colors.white:
                         Colors.black,
                         fontFamily: 'Poppins',
                       ),),),
                     ),
                   ),
                   GestureDetector(
                     onTap: (){
                       amount=125;
                       a=false;
                       b=true;
                       c=false;
                       d=false;
                       setState(() {});
                     },
                     child: Container(
                       padding: EdgeInsets.only(top: 4,bottom: 4,left: 10,right: 10),
                       decoration: BoxDecoration(
                           color: b?Colors.black:Colors.white,
                           border: Border.all(width: 1.4,color: b?Colors.white:Colors.black),
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: Center(child: Text('\$'+'125',style: TextStyle(
                         fontWeight: FontWeight.w800,
                         fontSize: 18,
                         color:b?Colors.white:
                         Colors.black,
                         fontFamily: 'Poppins',
                       ),),),
                     ),
                   ),

                   GestureDetector(
                     onTap: (){
                       amount=150;
                       a=false;
                       b=false;
                       c=true;
                       d=false;
                       setState(() {});
                     },
                     child: Container(
                       padding: EdgeInsets.only(top: 4,bottom: 4,left: 10,right: 10),
                       decoration: BoxDecoration(
                           color: c?Colors.black:Colors.white,
                           border: Border.all(width: 1.4,color: c?Colors.white:Colors.black),
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: Center(child: Text('\$'+'150',style: TextStyle(
                         fontWeight: FontWeight.w800,
                         fontSize: 18,
                         color:c?Colors.white:
                         Colors.black,
                         fontFamily: 'Poppins',
                       ),),),
                     ),
                   ),
                   GestureDetector(
                     onTap: (){
                       amount=200;
                       a=false;
                       b=false;
                       c=false;
                       d=true;
                       setState(() {});
                     },
                     child: Container(
                       padding: EdgeInsets.only(top: 4,bottom: 4,left: 10,right: 10),
                       decoration: BoxDecoration(
                           color: d?Colors.black:Colors.white,
                           border: Border.all(width: 1.4,color: d?Colors.white:Colors.black),
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: Center(child: Text('\$'+'200',style: TextStyle(
                         fontWeight: FontWeight.w800,
                         fontSize: 18,
                         color:d?Colors.white:
                         Colors.black,
                         fontFamily: 'Poppins',
                       ),),),
                     ),
                   ),
                 ],
               ),
               SizedBox(height: 50,),
               // Button for payment

               GestureDetector(
                 onTap: () {
                   makePayment().then((result) {
                     print("-------Payment result: $result--------------"); // Log the result
                     if (result == true){
                       int updateAmount=int.parse(walletvalue);
                       updateAmount+=amount;
                       FirebaseFirestore.instance.collection('Users').doc(userId).update({
                         'wallet':updateAmount,
                       });
                       // wallet+=walletvalue;
                       a=false;
                       b=false;
                       c=false;
                       d=false;
                       getWallet();
                       reload();

                     } else {
                       print('Error: Wallet not updated due to payment failure');
                     }
                   }).catchError((error) {
                     print("Error during payment: $error");
                   });
                 },
                 child: Container(
                   margin: EdgeInsets.symmetric(horizontal: 20),
                   padding: EdgeInsets.symmetric(vertical: 13),
                   decoration: BoxDecoration(
                     color: Color(0xff008080),
                     borderRadius: BorderRadius.circular(15),
                   ),
                   child: Center(
                     child: Text('Add Money',
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontFamily: 'Poppins',
                           fontSize: 15,
                           color: Colors.white
                       ),),
                   ),
                 ),
               )

             ],
           ),
         );
          })
    );
  }


  Future<bool> makePayment() async {
    try {
      paymentIntent = await paymentService.creatPaymentIntent(amount.toString(), 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: PaymentSheetGooglePay(merchantCountryCode: "+92",
              testEnv: true,
              currencyCode: 'USD'
          ),
          merchantDisplayName: "Mohsin",
        ),
      );
      final result = await displayPaymentSheet();
      return result;
    } catch (e) {
      print('Error $e');
      return false;
    }
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      if (e is StripeException && e.error.code == 'cancelled') {
        return false;
      }
      throw e;
    }
  }
}

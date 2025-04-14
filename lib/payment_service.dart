import 'dart:convert';

import 'package:food_app/app_constants.dart';
import 'package:http/http.dart'as http;
class PaymentService{
     creatPaymentIntent(String amount, String currency)async{
       try{
         Map<String,dynamic>body= {
         'amount' :(int.parse(amount)*100).toString(),
           'currency': currency,
           'payment_method_types[]':'card',
         };
         var SecretKey=secretKey;
         var response=await http.post(
             Uri.parse('https://api.stripe.com/v1/payment_intents'),
             headers: {
               'Authorization' :'Bearer $SecretKey',
               'Content-Type' :'application/x-www-form-urlencoded',
             },
           body: body
         );

         return jsonDecode(response.body.toString());
       }catch(e){
           print('Error $e');
       }
     }
}
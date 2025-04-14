import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Database/firebase_firestore.dart';
import 'package:food_app/textwidget.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}
class _CartState extends State<Cart> {
 Stream ? getItemStream;
String ? id=FirebaseAuth.instance.currentUser!.uid;
dbmethod db=dbmethod();
int total=0;
bool isLoading=false;
Future<void>ontheload()async{
   getItemStream=await db.getCartItems(id.toString());
   total = await calculateTotal();
   setState(() {
   });
}
 Future<int> calculateTotal() async {
   QuerySnapshot snapshot = await FirebaseFirestore.instance
       .collection('Users') // Adjust the collection name if needed
       .doc(id)
       .collection('Cart')
       .get();

   int sum = 0;
   for (var doc in snapshot.docs) {
     sum += int.parse(doc['Total']);
   }
   return sum;
 }

 Future<void> deleteItem(String documentId) async {
   try {
     await FirebaseFirestore.instance
         .collection('Users')
         .doc(id)
         .collection('Cart')
         .doc(documentId)
         .delete();

     // Recalculate total after deletion
     total = await calculateTotal();
     setState(() {});

     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Item removed from cart'),
         backgroundColor: Colors.green,
         duration: Duration(seconds: 2),
       ),
     );
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Failed to remove item'),
         backgroundColor: Colors.red,
         duration: Duration(seconds: 2),
       ),
     );
   }
 }


 String walletvalue='';
 Future<void>getWallet()async{
   DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection('Users').doc(id).get();
   if(snapshot.exists){
     setState(() {
       walletvalue=snapshot['wallet'].toString();
       print('Value of wallet is'+walletvalue+'of');
     });
     // walletvalue=wallet;
   }else{
     print('------No Wallet-------');
   }
 }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    ontheload();
    // startTimer();
    getWallet();
 }

  Widget cartItems(){
    return StreamBuilder(
        stream: getItemStream,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData? ListView.builder(
              itemCount: snapshot.data.docs.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context,index){
                DocumentSnapshot ds=snapshot.data.docs[index];

                return Dismissible(
                  key: Key(ds.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onDismissed: (direction) {
                    deleteItem(ds.id);
                  },
                  child: Container(margin: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        margin: EdgeInsets.only( left: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                              height: 70,
                              width: 30,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.5,color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(ds['Quantity'],style: TextStyle(
                                  fontSize: 15,
                                ),),
                              ),
                            ),
                            SizedBox(width: 15),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(imageUrl:
                                  ds['Image'],height:80 ,width: 80,fit: BoxFit.cover,
                                 placeholder: (context,index)=>SizedBox(

                                   child:  Center(
                                     child: Container(
                                       height: 10,
                                       width: 10,
                                       child: CircularProgressIndicator(
                                         color: Colors.orangeAccent,
                                       ),
                                     ),
                                   ),
                                 ),
                                )),
                            SizedBox(width: 25,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ds['Name'],style: textWidget.boldTextStyle(),),
                                Text("\$"+ds['Total'],style: textWidget.priceTextStyle(),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }):Center(child: CircularProgressIndicator(color: Colors.orangeAccent,),);

        });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Material(
            elevation: 5,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 45),
                child: Center(child: Text('Food Cart',style:TextStyle(
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    color: Colors.black
                ),),),
              ),
            ),
            SizedBox(height: 30,),
            Container(
                height: MediaQuery.of(context).size.height/1.8,
                child: cartItems()),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Price',style:TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w800,fontFamily: 'Poppins'),)
                  ,Text('\$'+total.toString(),style:
                  TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w900,fontFamily: 'Poppins'),)
                ],
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading=true;
                });
                // First check if cart is empty
                QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(id)
                    .collection('Cart')
                    .get();

                if (cartSnapshot.docs.isEmpty) {
                  setState(() {
                    isLoading=false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        'Cart is empty',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  return;
                }

                // If cart is not empty, proceed with checkout
                int amount = int.parse(walletvalue);
                if (amount < total) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        'Please add more money to wallet',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  try {
                    // Get all cart items for order record
                    List<Map<String, dynamic>> orderItems = cartSnapshot.docs
                        .map((doc) => {
                      'name': doc['Name'],
                      'quantity': doc['Quantity'],
                      'price': doc['Total'],
                      'image': doc['Image'],
                    })
                        .toList();

                    // Create new order document
                    int a=DateTime.now().millisecondsSinceEpoch;
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(id)
                        .collection('Orders').doc(a.toString())
                        .set({
                      'userId' :id,
                      'orderTotal': total,
                      'orderTime': DateTime.now(),
                      'orderStatus': 'pending',
                      'items': orderItems,
                      'orderNumber': a.toString(),
                      'deliveryAddress': '', // You can add this if you have address info
                      'paymentMethod': 'Wallet',
                      'estimatedDeliveryTime': DateTime.now().add(Duration(minutes: 30)),
                    });

                    await FirebaseFirestore.instance.collection('Orders').doc().set({
                      'OrderTime' :DateTime.now(),
                      'orderTotal': total,
                      'userId':id,
                      'items': orderItems,
                      'orderStatus': 'pending',
                      'deliveryAddress': '',
                      'orderNumber': a.toString(),
                    });

                    // Update wallet balance
                    int updateAmount = amount - total;
                    await FirebaseFirestore.instance.collection('Users').doc(id).update({
                      'wallet': updateAmount,
                    });

                    // Delete all items from cart
                    WriteBatch batch = FirebaseFirestore.instance.batch();
                    for (var doc in cartSnapshot.docs) {
                      batch.delete(doc.reference);
                    }
                    await batch.commit();

                    // Reset total and update UI
                    total=0;
                    setState(() {
                      isLoading=false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          'Order Placed Successfully',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(
                          'Error placing order. Please try again.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                }
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child:isLoading?Text(
                      'Processing...',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ): Text(
                      'CheckOut',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  )
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

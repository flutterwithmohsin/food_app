import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/textwidget.dart';

class DetailPage extends StatefulWidget {
   DetailPage({super.key,required this.name,required this.detail,required this.itemprice,required this.image});
String name;
String itemprice;
String detail;
String image;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  int a=1 ,total=0;
  bool isLoading=false;
  Future<void>addtoCart(String Image,String Quantity,String Name,String Total)async{

    String id=FirebaseAuth.instance.currentUser!.uid;
  await  FirebaseFirestore.instance.collection('Users').doc(id).collection('Cart').add(
        {   'Name': Name,
          'Total': Total,
          'Quantity': Quantity,
          'Image':Image,
        });
    setState(() {
      isLoading=false;
    });
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.orangeAccent,
      content: Text('Food Added To Cart',style: TextStyle(color: Colors.white),)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total=int.parse(widget.itemprice);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Icon(Icons.arrow_back_ios_new),
              ),
            ),
            SizedBox(height: 15,),
            CachedNetworkImage(imageUrl: widget.image,
              height:MediaQuery.of(context).size.height/2.5 ,
              width:MediaQuery.of(context).size.width ,
              placeholder: (context, url) =>
                  Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
             ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: textWidget.headlineTextStyle(),)
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(a>1){
                            --a;
                            total=total-int.parse(widget.itemprice);
                          }
                          setState(() {});
                        },
                        child: Container(
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:Colors.black,
                          ),
                          child: Icon(Icons.remove,color: Colors.white,),),
                      ),
                      SizedBox(width: 15,)
                      ,SizedBox(
                        width: 30,
                        child: Text(a.toString(), style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.5,
                          fontWeight: FontWeight.w600
                        ),),
                      ),
                      GestureDetector(
                        onTap: (){
                          ++a;
                          total=total+int.parse(widget.itemprice);
                          setState(() {});
                        },
                        child: Container(
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:Colors.black,
                          ),
                          child: Icon(Icons.add,color: Colors.white,),),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text(widget.detail
                  ,style: textWidget.lightTextStyle(),
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Text('Delivery Time', style: textWidget.semiTextStyle(),)
                  ,SizedBox(width: 30,),
                  Icon(Icons.timer_outlined,),
                  SizedBox(width: 4,),
                  Text('30 min', style: textWidget.semiTextStyle(),)
                ],
              ),
            ),SizedBox(height: 100,),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Total Price',style: textWidget.boldTextStyle(),),
                    Text('\$'+total.toString(),style: textWidget.priceTextStyle(),),
                  ],),
                  SizedBox(width: 60,),
                  GestureDetector(
                    onTap: ()async{
                      setState(() {
                        isLoading=true;
                      });
                     await addtoCart(widget.image.toString(), a.toString(), widget.name.toString(), total.toString());
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,),
                        child: Row(
                          children: [isLoading? Text('Adding...',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500),)
                            :Text('Add to Cart',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500),),
                            SizedBox(width: 18),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey,
                              ),
                              child: Icon(Icons.shopping_cart_outlined,color: Colors.white,),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
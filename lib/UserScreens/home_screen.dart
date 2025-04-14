import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Database/firebase_firestore.dart';
import 'package:food_app/UserScreens/order.dart';
import 'package:food_app/detail_page.dart';
import 'package:food_app/textwidget.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool icecream=false, pizza=false,burger=false,salad=false;
  final dbmethod db=dbmethod();
  String firstName='';
  String? id=FirebaseAuth.instance.currentUser!.uid;
  Stream<QuerySnapshot> ?fooditemStream;
  Future<void> ontheload() async {
    try {
      print("Starting ontheload function"); // Debug print

      // Directly assign the stream
      fooditemStream =await db.getFoodItems('Pizza');

      // Separate get() call for immediate data check
      var documents = await FirebaseFirestore.instance.collection('Pizza').get();
      print("Documents found: ${documents.docs.length}");
      for (var doc in documents.docs) {
        print("Document ID: ${doc.id}, Data: ${doc.data()}");
      }

      setState(() {
        // Trigger rebuild after stream is initialized
      });
    } catch (e) {
      print("Error in ontheload: $e");
    }
  }
  Future<void>getUserdata()async{
    DocumentSnapshot ds=await FirebaseFirestore.instance.collection('Users').doc(id).get();
    String userName = ds['username']; // Assuming ds is a Map or similar
    firstName = userName.split(' ')[0]; // Split by space and take the first word
    print(firstName); // This will print "Muhammad"
  }

  @override
  void initState() {
    super.initState();
    print("initState called");
    getUserdata();
// Debug print
    ontheload();
  }



  Widget allitems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                              name: ds['Name'],
                              detail: ds['Detail'],
                              itemprice: ds['Price'],
                              image: ds['imageUrl'],
                            )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15, bottom: 10),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: ds['imageUrl'],
                                height: 150,
                                width: 150,
                                 placeholder: (context, url) =>
                                     Center(
                                       child: Container(
                                         height: 20,
                                         width: 20,
                                         child: CircularProgressIndicator(
                                           color: Colors.orangeAccent,
                                         ),
                                       ),
                                     ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              ds['Name'],
                              style: textWidget.semiTextStyle(),
                            ),
                            Text(
                              'Fresh and Healthy',
                              style: textWidget.lightTextStyle(),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '\$' + ds['Price'],
                              style: textWidget.priceTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
              : Center(
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ),
          );
        });
  }


  Widget allitemsvertically(){
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData? ListView.builder(
              itemCount: snapshot.data.docs.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context,index){
                DocumentSnapshot ds=snapshot.data.docs[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>DetailPage(name: ds['Name'], detail: ds['Detail'], itemprice: ds['Price'], image: ds['imageUrl'])));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: ds['imageUrl'],
                                height: 120,
                                width: 120,
                                placeholder: (context, url) =>
                                    Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.orangeAccent,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width:MediaQuery.of(context).size.width/2,
                                    child: Text(ds['Name'], style: textWidget.semiTextStyle(),)),
                                Text('Honey with Goat',style: textWidget.lightTextStyle(),)
                                ,Text('\$'+ds['Price'],style: textWidget.priceTextStyle(),)
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

  Widget Categories(){
    return Padding(
      padding: const EdgeInsets.only(left: 7,right: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap:()async{
              pizza =true;
              burger =false;
              icecream =false;
              salad =false;
              fooditemStream =await db.getFoodItems('Pizza');
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: pizza?Colors.black:Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset('images/pizza.png',fit: BoxFit.fill,height: 40, width: 40,color: pizza?Colors.white:Colors.black,),
              ),
            ),
          ),
          GestureDetector(
            onTap: ()async{
              pizza=false;
              burger=true;
              salad=false;
              icecream=false;
              fooditemStream =await db.getFoodItems('Burger');
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: burger?Colors.black:Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset('images/burger.png',fit: BoxFit.fill,height: 40, width: 40,color: burger?Colors.white:Colors.black,),
              ),
            ),
          ),
          GestureDetector(
            onTap: ()async{
              burger=false;
              icecream=true;
              salad=false;
              pizza=false;
              fooditemStream =await db.getFoodItems('Ice-cream');
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: icecream?Colors.black:Colors.white,
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset('images/ice-cream.png',fit: BoxFit.fill,height: 40, width: 40,
                  color: icecream?Colors.white:Colors.black,),
              ),
            ),
          ),
          GestureDetector(
            onTap: ()async{
              burger=false;
              icecream=false;
              salad=true;
              pizza=false;
              fooditemStream =await db.getFoodItems('Salad');
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: salad?Colors.black:Colors.white,
                  borderRadius: BorderRadius.circular(10),),
                padding: EdgeInsets.all(8),
                child: Image.asset('images/salad.png',fit: BoxFit.fill,height: 40, width: 40,
                  color: salad?Colors.white:Colors.black,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header And Cart Icon
              Padding(
                padding: const EdgeInsets.only(right: 15,left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(firstName+',',style: textWidget.boldTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>Cart()));
                      },
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.shopping_cart_outlined,color: Colors.white,),),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Delicious Food', style: textWidget.headlineTextStyle(),),
              ),
              Padding(
                padding: const EdgeInsets.only(left:15),
                child: Text('Discover and Get Great Food', style: textWidget.lightTextStyle(),),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.only(right: 15,left: 15),
                child: Categories(),
              ),
              SizedBox(height: 20,),
             Padding(
               padding: const EdgeInsets.only(right: 15,),
               child: Container(
                 height: 270,
                 child: allitems(),
               ),
             ),
              // Vertical Container
              Container(
                height: MediaQuery.of(context).size.height/2.8,
                margin: EdgeInsets.only(bottom: 15,),
                  child: allitemsvertically()),
            ],
          ),
        ),
      ),
    );
  }

}
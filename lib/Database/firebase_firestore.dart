import 'package:cloud_firestore/cloud_firestore.dart';


class dbmethod{
  Future<Stream<QuerySnapshot>>getFoodItems(String name)async{
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future<Stream<QuerySnapshot>>getCartItems(String id)async{
    return await FirebaseFirestore.instance.collection('Users').doc(id).collection('Cart').snapshots();
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/textwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
class AddFoodItem extends StatefulWidget {
  const AddFoodItem({super.key});

  @override
  State<AddFoodItem> createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  final List<String> items = ['Ice-cream', 'Pizza', 'Salad', 'Burger'];
  String? value;
  bool isLoading=false;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? selectedImage;
  final imgbbkey="616a3a48df7fa0dbdb1c45340326e85c";

  Future getImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }
  void clearFields() {
    setState(() {
      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      value = null;
      selectedImage = null;
    });
  }
  Future uploadImage()async{
  if(selectedImage==null||nameController.text.isEmpty||priceController.text.isEmpty||descriptionController.text.isEmpty||value==null){
    setState(() {
      isLoading=false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        // padding: EdgeInsets.all( 10),
        content: Text('Please Fill all fields',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),)));
  }else{
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbkey"),
    );
    request.files.add(await http.MultipartFile.fromPath("image", selectedImage!.path));
    final response = await request.send();
    if(response.statusCode==200){
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      final imageUrl = jsonResponse['data']['url'];
      await FirebaseFirestore.instance.collection(value.toString()).add({
        'imageUrl': imageUrl,
        'Name':nameController.text.trim(),
        'Price' :priceController.text.trim(),
        'Detail' :descriptionController.text.trim(),
      });

      clearFields();
      setState(() {
        isLoading=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          // padding: EdgeInsets.symmetric(horizontal: 10),
          content: Text('Image Uploaded Successfully',style: TextStyle(color: Colors.white),)));
    }else{
      setState(() {
        isLoading=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          // padding: EdgeInsets.symmetric(horizontal: 10),
          content: Text('Error Uploading Image',style: TextStyle(color: Colors.white),)));
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
              )),
          elevation: 3,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Add Food Items',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(child: Text('Add Pictures', style: textWidget.semiTextStyle(),)),
                SizedBox(
                  height: 15,
                ),
                // Picture Container
                // -----------------
                if (selectedImage == null)
                  GestureDetector(
                    onTap: () {
                      getImage();
                      setState(() {});
                    },
                    onSecondaryTap: () async {
                      await getImage();
                      setState(() {});
                    },
                    child: Center(
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(width: 1.9, color: Colors.black)),
                          child: Center(
                            child: Icon(Icons.camera_alt_outlined,
                                color: Colors.black, size: 35),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    // Added GestureDetector here
                    onTap: () {
                      getImage();
                      setState(() {});
                    },
                    onSecondaryTap: () async {
                      await getImage();
                      setState(() {});
                    },
                    child: Center(
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(width: 1.9, color: Colors.black)),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.fill,
                                height: 150,
                                width: 150,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ), // -----------------
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Item Name',
                    style: textWidget.semiTextStyle(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Item Name',
                        hintStyle: textWidget.lightTextStyle()),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Item Price',
                    style: textWidget.semiTextStyle(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Item Price',
                        hintStyle: textWidget.lightTextStyle()),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Item Detail',
                    style: textWidget.semiTextStyle(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 150,
                    controller: descriptionController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Item Detail',
                        hintStyle: textWidget.lightTextStyle()),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Select Category',
                    style: textWidget.semiTextStyle(),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                    items: items
                        .map((items) => DropdownMenuItem<String>(
                            value: items,
                            child: Text(
                              items,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  color: Colors.black),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 36,
                    ),
                    hint: Text('Select Category'),
                    value: value,
                  )),
                ),
                SizedBox(
                  height: 35,
                ),
                Center(
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                     onTap: ()async{
                       // await uploadImage();
                       setState(() {
                         isLoading=true;
                       });
                       print('------Tap--------');
                       await uploadImage();
                     },
                      child:isLoading?Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Center(
                          child: Lottie.asset('images/loader.json',height: 50,width: 50),
                        ),
                      ): Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ));
  }

}

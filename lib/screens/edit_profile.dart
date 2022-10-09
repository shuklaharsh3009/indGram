import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indgram/resources/storage_methods.dart';
import 'package:indgram/screens/profile.dart';
import 'package:indgram/utils/colors.dart';
import 'package:indgram/utils/util.dart';
import 'package:indgram/widgets/custom_button.dart';
import 'package:indgram/widgets/text_field_input.dart';
import '../main.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  String photoUrl = "";
  String username = "";
  String bio = "";
  String fullName = "";
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  Uint8List? _image;
  bool _isSaving = false;

  @override
  void dispose() {
    super.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage( ImageSource.gallery );
    setState(() {
      _image = img;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('users')
      .doc( FirebaseAuth.instance.currentUser!.uid)
      .get();

    setState(() {
      username = ( snap.data() as Map< String, dynamic> )['username'];
      fullName = ( snap.data() as Map< String, dynamic> )['fullName'];
      bio = ( snap.data() as Map< String, dynamic> )['bio'];
      photoUrl = ( snap.data() as Map< String, dynamic> )['photoUrl'];
    },);
  }

  void updateUserInfo() async {
    setState(() {
      _isSaving = true;
    });

    //updating the changed values...
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    if( _image != null ){
      String pUrl = await StorageMethods().uploadImageToStorage('profilePics', _image!, false );
      fireStore.collection('users')
        .doc( auth.currentUser!.uid )
        .update( {'photoUrl' : pUrl} );
    }
    if( _fullNameController.text != "" ){
      fireStore.collection('users')
        .doc( auth.currentUser!.uid )
        .update( {'fullName' : _fullNameController.text} );
    }
    if( _usernameController.text != "" ){
      fireStore.collection('users')
        .doc( auth.currentUser!.uid )
        .update( {'username' : _usernameController.text} );
    }
    if( _bioController.text != "" ){
      fireStore.collection('users')
        .doc( auth.currentUser!.uid )
        .update( {'bio' : _bioController.text} );
    }

    setState(() {
      _isSaving = false;
      _fullNameController.text = "";
      _usernameController.text = "";
      _bioController.text = "";
      getUserInfo();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            centerTitle: true,
            elevation: 0,
            backgroundColor: primaryColor,
            leading: IconButton(onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const  ProfileScreen() ));
            }, 
            icon: const Icon( Icons.arrow_back), color: Colors.black,),
          ),
          body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth! * 0.07),
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight! * 0.05,
                ),
                // Circular Avatar to get profile picture...
                Stack(
                  children: [
                    _image != null ? 
                    CircleAvatar(
                      radius: screenWidth!*0.12 ,
                      backgroundImage: MemoryImage(_image!),
                    )
                    : CircleAvatar(
                      radius: screenWidth!*0.12 ,
                      backgroundImage: NetworkImage( photoUrl ),
                    ),
                    Positioned(
                      bottom: -screenWidth!*0.03,
                      left: screenWidth!*0.14,
                      child: IconButton(
                        onPressed: selectImage, 
                        icon: const Icon(Icons.add_circle)
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight! * 0.05),
                //Full Name input textfield
                TextFieldInput(
                  textEditingController: _fullNameController,
                  hintText: fullName,
                  textInputType: TextInputType.text,
                  icon: const Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight! * 0.03),
                //UserName input textfield
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: username,
                  textInputType: TextInputType.text,
                  icon: const Icon(
                    Icons.person_add_alt_outlined,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight! * 0.03),
                //Bio input textfield
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: bio,
                  textInputType: TextInputType.text,
                  icon: const Icon(
                    Icons.beenhere_outlined,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight! * 0.03),
                //Sign Up button
                InkWell(
                  onTap: updateUserInfo,
                  child: CustomButton(
                    text: _isSaving? "Saving..." :"Done",
                    width: screenWidth! * 0.86,
                    color: Colors.amber,
                    fontSize: screenHeight! * 0.036,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
              ),
        )),
    ); 
  }
}
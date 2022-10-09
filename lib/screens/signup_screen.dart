import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indgram/resources/auth_method.dart';
import 'package:indgram/screens/edit_profile.dart';
import 'package:indgram/utils/util.dart';
import 'package:indgram/widgets/custom_button.dart';
import 'package:indgram/widgets/text_field_input.dart';
import '../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUser(
      file: _image!, 
      fullName: _fullNameController.text, 
      username: _usernameController.text, 
      email: _emailController.text, 
      password: _passwordController.text, 
      bio: _bioController.text
    );
    if( res != "success"){
      showSnackBar(context, 'Unable to create account');
    } else {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditProfile() ));
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth! * 0.07),
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight! * 0.05,
              ),
              //Sign Up Text
              Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: screenHeight! * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: screenHeight! * 0.01,
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
                    backgroundImage: const NetworkImage('https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg'),
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
              SizedBox(height: screenHeight! * 0.02),
              //Full Name input textfield
              TextFieldInput(
                textEditingController: _fullNameController,
                hintText: "Enter your Full Name",
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
                hintText: "Enter your Username",
                textInputType: TextInputType.text,
                icon: const Icon(
                  Icons.person_add_alt_outlined,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight! * 0.03),
              //email input textfield
              TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your Email",
                textInputType: TextInputType.emailAddress,
                icon: const Icon(
                  Icons.email_outlined,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight! * 0.03),
              //password input textfield
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Enter your Password",
                textInputType: TextInputType.text,
                isPass: true,
                icon: const Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight! * 0.03),
              //Bio input textfield
              TextFieldInput(
                textEditingController: _bioController,
                hintText: "Enter your Bio",
                textInputType: TextInputType.text,
                icon: const Icon(
                  Icons.beenhere_outlined,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight! * 0.03),
              //Sign Up button
              InkWell(
                onTap: signUpUser,
                child: CustomButton(
                  text: _isLoading? "Loading..." :"Sign Up",
                  width: screenWidth! * 0.86,
                  color: Colors.amber,
                  fontSize: screenHeight! * 0.036,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indgram/resources/auth_method.dart';
import 'package:indgram/screens/edit_profile.dart';
import 'package:indgram/screens/signup_screen.dart';
import 'package:indgram/utils/util.dart';
import 'package:indgram/widgets/custom_button.dart';
import 'package:indgram/widgets/text_field_input.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = false;
    });
    String res = await AuthMethods().LoginUser(email: _emailController.text, password: _passwordController.text );
    if( res == "Success" ){
      setState(() {
      _isLoading = true;
    });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditProfile() ));
    } else {
      setState(() {
      _isLoading = true;
    });
      showSnackBar( context, res );
    }
    
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
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
                height: screenHeight! * 0.2,
              ),
              //Login Text
              Text(
                'Login',
                style: TextStyle(
                    fontSize: screenHeight! * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: screenHeight! * 0.1,
              ),
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
              SizedBox(height: screenHeight! * 0.05),
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
              SizedBox(height: screenHeight! * 0.05),
              //login button
              InkWell(
                onTap: loginUser,
                child: CustomButton(
                  text: _isLoading? "Loading...":"Login",
                  width: screenWidth! * 0.86,
                  color: Colors.amber,
                  fontSize: screenHeight! * 0.036,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight! * 0.225),
              //signup page redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: navigateToSignup,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
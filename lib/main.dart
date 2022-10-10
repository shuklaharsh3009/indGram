import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:indgram/providers/user_providers.dart';
import 'package:indgram/screens/edit_profile.dart';
import 'package:indgram/screens/login_screen.dart';
import 'package:indgram/utils/colors.dart';
import 'package:provider/provider.dart';

double? screenWidth;
double? screenHeight;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const IndGram() );
}

class IndGram extends StatelessWidget {
  const IndGram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "IndGram",
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if( snapshot.connectionState == ConnectionState.active ){
              if( snapshot.hasData ){
                return const EditProfile();
              } else if( snapshot.hasError ){
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            if( snapshot.connectionState == ConnectionState.waiting ){
              return const Center(
                child: CircularProgressIndicator(
                  color: blueColor,
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
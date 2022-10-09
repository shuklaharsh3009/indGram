import 'dart:typed_data';
import '../models/users.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:indgram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future <model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // Sign Up User
  Future<String> SignUpUser(
    {
      required Uint8List file,
      required String fullName,
      required String username,
      required String email,
      required String password,
      required String bio,
    }
  ) async {
    String res = "Some Error Occured!";
    try{
      if( fullName.isNotEmpty || username.isNotEmpty || email.isNotEmpty || password.isNotEmpty || file != null || bio.isNotEmpty ){
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        //Uploading image in firebase storage and getting it's url
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false );
        
        //add user to database
        model.User user = model.User(
          fullName : fullName,
          username : username,
          uid : cred.user!.uid,
          email : email,
          bio : bio,
          followers : [],
          following : [],
          photoUrl : photoUrl
        );

        await _firestore.collection('users').doc( cred.user!.uid ).set(user.toJson(),);
        res = "success";
      }
    } catch( err ) {
      res = err.toString();
    }
    return res;
  }

  //Login User
  Future<String> LoginUser({
    required String email,
    required String password
  }) async {
    String res = "Some Error Occured!";
    try{
      if( email.isNotEmpty || password.isNotEmpty ){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success";
      }
      else {
        res = "Please Enter all the fields!";
      }
    } catch ( err ){
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

}
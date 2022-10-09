import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indgram/screens/search_screen.dart';
import 'package:indgram/screens/user_profile.dart';
import '../screens/add_posts.dart';

List<Widget> homeScreenItems = [
  UserProfileScreen( uid: FirebaseAuth.instance.currentUser!.uid ,),
  const SearchScreen(),
  const Text('Home'),
  const Text('Liked'),
  const AddPostScreen(),
];
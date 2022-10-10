import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:indgram/main.dart';
import 'package:indgram/screens/add_posts.dart';
import 'package:indgram/screens/feed_screen.dart';
import 'package:indgram/screens/search_screen.dart';
import 'package:indgram/screens/user_profile.dart';
import 'package:indgram/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _page = 0;
  late PageController pageController;
  FirebaseAuth user = FirebaseAuth.instance;
  String currentUserUid = '';

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void getCurrentUser() async {
    setState(() {
      currentUserUid = user.currentUser!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            UserProfileScreen(
              uid: currentUserUid,
            ),
            const SearchScreen(),
            const FeedScreen(),
            const AddPostScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          color: primaryColor,
          padding: EdgeInsets.all( screenWidth!*0.03 ),
          child: GNav(
            backgroundColor: primaryColor,
            padding: EdgeInsets.all( screenWidth!*0.02 ),
            gap: screenWidth!*0.02,
            iconSize: screenHeight!*0.04,
            tabs: [
              // Profile
              GButton(
                icon: Icons.person_outlined,
                text: 'Profile',
                iconColor: Colors.black,
                iconActiveColor: Colors.green.shade700,
                textStyle: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight!*0.025,
                ),
                backgroundColor: Colors.green.shade100,
              ),
              // Search
              GButton(
                icon: Icons.search,
                text: 'Search',
                iconColor: Colors.black,
                iconActiveColor: Colors.amber.shade700,
                textStyle: TextStyle(
                  color: Colors.amber.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight!*0.025,
                ),
                backgroundColor: Colors.amber.shade100,
              ),
              // Feed/Home
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
                iconColor: Colors.black,
                iconActiveColor: Colors.green.shade700,
                textStyle: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight!*0.025,
                ),
                backgroundColor: Colors.green.shade100,
              ),
              // Add Post
              GButton(
                icon: Icons.add_circle_outline,
                text: 'Post',
                iconColor: Colors.black,
                iconActiveColor: Colors.amber.shade700,
                textStyle: TextStyle(
                  color: Colors.amber.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight!*0.025,
                ),
                backgroundColor: Colors.amber.shade100,
              ),
            ],
            onTabChange: navigationTapped,
          ),
        ),
      ),
    );
  }
}
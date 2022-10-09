import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indgram/utils/colors.dart';
import 'package:indgram/utils/global_variables.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped( int page ) {
    pageController.jumpToPage(page);
  }

  void onPageChanged( int page ) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          children: homeScreenItems,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: primaryColor,
          border: const Border(top: BorderSide.none ),
          items: [
            // Profile tab
            BottomNavigationBarItem(
              icon: Icon( 
                Icons.person,
                color: _page == 0 ? Colors.amber : Colors.grey.shade600, 
              ),
              label: "",
              backgroundColor: primaryColor
            ),
            // Search tab
            BottomNavigationBarItem(
              icon: Icon( 
                Icons.search,
                color: _page == 1 ? Colors.amber : Colors.grey.shade600, 
              ),
              label: "",
              backgroundColor: primaryColor
            ),
            // Home tab
            BottomNavigationBarItem(
              icon: Icon( 
                Icons.home_filled,
                color: _page == 2 ? Colors.amber : Colors.grey.shade600, 
              ),
              label: "",
              backgroundColor: primaryColor
            ),
            // Liked tab
            BottomNavigationBarItem(
              icon: Icon( 
                Icons.favorite,
                color: _page == 3 ? Colors.amber : Colors.grey.shade600, 
              ),
              label: "",
              backgroundColor: primaryColor
            ),
            // Add Post tab
            BottomNavigationBarItem(
              icon: Icon( 
                Icons.add_circle,
                color: _page == 4 ? Colors.amber : Colors.grey.shade600,  
              ),
              label: "",
              backgroundColor: primaryColor
            ),
          ],
          onTap: navigationTapped,
        ),
      ),
    );
  }
}
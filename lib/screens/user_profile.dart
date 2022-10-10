import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indgram/main.dart';
import 'package:indgram/resources/auth_method.dart';
import 'package:indgram/resources/firestor_methods.dart';
import 'package:indgram/screens/edit_profile.dart';
import 'package:indgram/screens/login_screen.dart';
import 'package:indgram/utils/colors.dart';
import 'package:indgram/utils/util.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;
  const UserProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followersLen = 0;
  int followingsLen = 0;
  bool isFollowing = false;
  bool isLoading = false;
  String editProfile = "EditProfile";
  String signOut = "SignOut";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;

      //get Post Length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      followersLen = userData['followers'].length;
      followingsLen = userData['following'].length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: primaryColor,
                title: Text(userData['username']),
                titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                centerTitle: true,
                actions: [
                  PopupMenuButton(
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: editProfile,
                        child: const Text('Edit Profile'),
                      ),
                      PopupMenuItem(
                        value: signOut,
                        child: const Text('Sign Out'),
                      ),
                    ],
                    onSelected: (value) async {
                      if( value == editProfile ){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const EditProfile()));
                      } else {
                        await AuthMethods().signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                      }
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(screenWidth! * 0.05),
                          bottomRight: Radius.circular(screenWidth! * 0.05),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade700,
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 0,
                            blurRadius: screenHeight! * 0.05,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Photo
                          Center(
                            child: CircleAvatar(
                              radius: screenWidth! * 0.12,
                              backgroundImage:
                                  NetworkImage(userData['photoUrl']),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight! * 0.02,
                          ),
                          // Full Name of the user
                          Text(
                            userData['fullName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight! * 0.01,
                          ),
                          // Bio of the User
                          Text(
                            userData['bio'],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight! * 0.01,
                          ),
                          // Posts,Followers,Following
                          Row(
                            children: [
                              //Posts
                              SizedBox(
                                width: screenWidth! * 0.33,
                                child: Column(
                                  children: [
                                    Text(
                                      'Posts',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    Text(
                                      '$postLen',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenHeight! * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Followers
                              SizedBox(
                                width: screenWidth! * 0.33,
                                child: Column(
                                  children: [
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    Text(
                                      followersLen.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenHeight! * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Following
                              SizedBox(
                                width: screenWidth! * 0.33,
                                child: Column(
                                  children: [
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    Text(
                                      followingsLen.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenHeight! * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                                  height: screenHeight! * 0.02,
                                ),
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? const SizedBox(
                                  height: 0,
                                )
                              :
                              // Follow/Following Button
                              isFollowing?
                              GestureDetector(
                                  onTap: () async {
                                    await FireStoreMethods().followUser( FirebaseAuth.instance.currentUser!.uid , userData['uid'] );
                                    setState(() {
                                      isFollowing = false;
                                      followersLen--;
                                    });
                                  },
                                  child: Container(
                                    width: screenWidth! * 0.9,
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.all(screenWidth! * 0.015),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  screenWidth! * 0.02)),
                                          side: const BorderSide(
                                            color: Colors.amber,
                                          )),
                                      color: primaryColor,
                                    ),
                                    child: Text('Following',
                                      style: TextStyle(
                                        fontSize: screenWidth! * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                )
                               : GestureDetector(
                                  onTap: () async {
                                    await FireStoreMethods().followUser( FirebaseAuth.instance.currentUser!.uid , userData['uid'] );
                                    setState(() {
                                      isFollowing = true;
                                      followersLen++;
                                    });
                                  },
                                  child: Container(
                                    width: screenWidth! * 0.9,
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.all(screenWidth! * 0.015),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  screenWidth! * 0.02)),
                                          side: const BorderSide(
                                            color: Colors.amber,
                                          )),
                                      color: Colors.amber,
                                    ),
                                    child: Text('Follow',
                                      style: TextStyle(
                                        fontSize: screenWidth! * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: screenHeight! * 0.02,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight! * 0.05,
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          primary: false, //Enables Scrolling 
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return Container(
                              margin: EdgeInsets.all(screenWidth! * 0.015),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth! * 0.05)),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(snap['postUrl']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

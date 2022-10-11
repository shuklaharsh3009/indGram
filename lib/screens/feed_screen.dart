
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indgram/main.dart';
import 'package:indgram/utils/colors.dart';
import 'package:indgram/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = screenWidth;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              elevation: 0,
              centerTitle: false,
              title: const Text('IndGram'),
              titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
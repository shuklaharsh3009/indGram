import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String email;
  final String uid;
  final String photoUrl;
  final List following;
  final List followers;
  final String fullName;
  final String username;
  final String bio;

  const User({
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.fullName,
    required this.photoUrl,
    required this.uid,
    required this.username,
  });

  Map < String, dynamic > toJson() => {
    'fullName' : fullName,
    'username' : username,
    'uid' : uid,
    'email' : email,
    'bio' : bio,
    'followers' : followers,
    'following' : following,
    'photoUrl' : photoUrl
  };

  static User fromSnap( DocumentSnapshot snap ){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'], 
      bio: snapshot['bio'], 
      followers: snapshot['followers'], 
      following: snapshot['following'], 
      fullName: snapshot['fullName'], 
      photoUrl: snapshot['photoUrl'], 
      uid: snapshot['uid'], 
      username: snapshot['username']
    );
  }

}
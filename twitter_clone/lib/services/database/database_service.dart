/*

DATABASE SERVICE

This class handles all the data from and to firebase.

--------------------------------------------------------------------------------

- User profile 
- Post message
- Likes
- Comments
- Account stuff ( report / block / delete account )
- Follow / un follow
- Search users...


*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/models/post.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';

class DatabaseService {
  // get instance of
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*

  USER PROFILE

  When a new user register, we create an account for them, but let's also store
  their details in the database to display on their profile page.

  */

  // Save user info
  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    // get current uid
    String uid = _auth.currentUser!.uid;

    // extract username from email
    String username = email.split('@')[0];

    // create a user profile
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    // convert user into a map so that we can store in firebase
    final userMap = user.toMap();

    // save user info in firebase
    await _db.collection("Users").doc(uid).set(userMap);
  }

  // Get user info
  Future<UserProfile?> getUserFormFirebase(String uid) async {
    try {
      // retrieve user doc from firebase
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      // convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update user bio
  Future<void> updateUserBioInFirebase(String bio) async {
    // get current uid
    String uid = AuthService().getCurrentUid();

    // attempt to update in firebase
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  /*
  
  POST MESSAGE 
  
  */

  // Post a message
  Future<void> postMessageInFirebase(String message) async {
    //try to post message
    try {
      // get current uid
      String uid = _auth.currentUser!.uid;

      // use this uid to get the user's profile
      UserProfile? user = await getUserFormFirebase(uid);

      // create a new post
      Post newPost = Post(
        id: '', // firebase will auto generate this
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );

      // convert post object -> map
      Map<String, dynamic> newPostMap = newPost.toMap();

      // add to firebase
      await _db.collection("Posts").add(newPostMap);
    }
    // catch any error..
    catch (e) {
      print(e);
    }
  }

  // Delete a post

  // Get all posts
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db

          // go to collection -> Posts
          .collection("Posts")
          // chronological order
          .orderBy('timestamp', descending: true)
          // get this data
          .get();

      // return as a list of posts
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

  // Get individual post

  /*
  
  LIKES 

  */

  /*
  
  COMMENTS

  */

  /*
  
  ACCOUNT STUFF

  */

  /*
  
  FOLLOW

  */

  /*
  
  SEARCH

  */
}

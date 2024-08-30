// go to user page
import 'package:flutter/material.dart';
import 'package:twitter_clone/models/post.dart';
import 'package:twitter_clone/pages/profile_page.dart';

import '../pages/post_page.dart';

// go to user page
void goUserPage(BuildContext context, String uid) {
  // navigate to the page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid),
    ),
  );
}

// go to post page
void goPostPage(BuildContext context, Post post) {
  // navigate to post page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(post: post),
    ),
  );
}

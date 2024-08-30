import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/models/post.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';
import 'package:twitter_clone/services/database/database_provider.dart';
/*

POST TILE

All posts will be displayed using this post tile widget.

--------------------------------------------------------------------------------

To use this widget, you need:

- the post 
- a function for onPostTap ( go to the individual post to see it's comments )
- a function for onUserTap ( go to user's profile page  )

*/

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  /*

  LIKES

  */

  // user tapped like (or unlike)
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  // show options for post
  void _showOptions() {
    // check if this post is owned by the use or not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;

    // show options
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // THIS POST BELONGS TO USER
              if (isOwnPost)
                // delete message button
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    // pop option box
                    Navigator.pop(context);

                    // handle delete action
                    await databaseProvider.deletePost(widget.post.id);
                  },
                )
              // THIS POST DOES NOT BELONG TO USER
              else ...[
                // report post button
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Report"),
                  onTap: () {
                    // pop options box
                    Navigator.pop(context);

                    // handle report action
                  },
                ),
                // block user button
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Block User"),
                  onTap: () {
                    // pop options box
                    Navigator.pop(context);

                    // handle block action
                  },
                ),
              ],
              // cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // does the current user like this post?
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentUser(widget.post.id);

    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    // Container
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        // Padding outside
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

        // Padding inside
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // Color of post tile
          color: Theme.of(context).colorScheme.secondary,

          // Curve corners
          borderRadius: BorderRadius.circular(8),
        ),

        // Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: profile pic / name / username
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  // profile pic
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  // name
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  // username handle
                  Text(
                    '@${widget.post.username}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  // buttons -> more options: delete
                  GestureDetector(
                    onTap: _showOptions,
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // message
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 20),

            // buttons -> like & comment
            Row(
              children: [
                // like button
                GestureDetector(
                  onTap: _toggleLikePost,
                  child: likedByCurrentUser
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                ),

                const SizedBox(
                  width: 5,
                ),
                // like count
                Text(
                  likeCount != 0 ? likeCount.toString() : '',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

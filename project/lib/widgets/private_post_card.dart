//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/user.dart' as model;
import 'package:project/screens/comments_screen.dart';
import 'package:project/utils/colors.dart';
import 'package:project/utils/utils.dart';
import 'package:project/widgets/like_animation.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../screens/profile_screen.dart';

class PrivatePostCard extends StatefulWidget {
  final snap;
  const PrivatePostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PrivatePostCard> createState() => _PrivatePostCardState();
}

class _PrivatePostCardState extends State<PrivatePostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    if(widget.snap['uid'] == FirebaseAuth.instance.currentUser!.uid){
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                // Header Section
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: widget.snap['uid'],
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        NetworkImage(widget.snap['profImage'].toString()),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            children: [
                              SimpleDialogOption(
                                  padding: const EdgeInsets.all(20),
                                  child: const Text('Delete Post'),
                                  onPressed: () async {
                                    if (widget.snap['uid'] ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      FirestoreMethods()
                                          .deletePost(widget.snap['postId']);
                                      Navigator.of(context).pop();
                                      showSnackBar('Post Deleted', context);
                                    } else {
                                      showSnackBar(
                                          "Cannot delete others' posts",
                                          context);
                                    }
                                  }),
                              SimpleDialogOption(
                                  padding: const EdgeInsets.all(20),
                                  child: const Text('Change Post Privacy'),
                                  onPressed: () async {
                                    if (widget.snap['isPrivate'] == false) {
                                      FirestoreMethods().setPostAsPrivate(
                                          widget.snap['postId']);
                                      Navigator.of(context).pop();
                                      showSnackBar('Post set as Private', context);
                                    } else {
                                       FirestoreMethods().setPostAsPublic(
                                          widget.snap['postId']);
                                      Navigator.of(context).pop();
                                      showSnackBar('Post set as Public', context);
                                    }
                                  }),
                              SimpleDialogOption(
                                padding: const EdgeInsets.all(20),
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),

          //Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    }),
              ),
            ]),
          ),

          //Like Comment Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () {},
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: selectedIconColor,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
            ],
          ),

          //Description and no. of commentss
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: greyColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: greyColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }else{return Container();}} 
}

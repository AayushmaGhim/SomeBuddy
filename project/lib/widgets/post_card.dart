import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/user.dart';
import 'package:project/utils/colors.dart';
import 'package:project/widgets/like_animation.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
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
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
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
                        builder: (context) => Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map(
                                      (e) => InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ));
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),

          //Image Section
          GestureDetector(
            onDoubleTap: () async{
              await FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes']
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating? 1: 0,
                child: LikeAnimation(
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: (){
                    setState(() {
                      isLikeAnimating = false;
                    });
                  } 
                ),
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
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_border,
                    ),
                  ),
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
                    '${widget.snap['likes'].length}',
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
                      'View all 200 comments',
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
  }
}

import 'package:flutter/cupertino.dart';
import 'package:realestate/views/post_widget.dart';
import '../models/core/country.dart';
import '../models/core/post/post.dart';

class PostEditWidget extends StatelessWidget {
  final Post post;
  final UseType type;
  final Country? countryInfo;
  final Function() onClicked;
  final Function() onLongPressed;
  const PostEditWidget(
      {required this.onLongPressed,
      required this.type,
      this.countryInfo,
      required this.post,
      required this.onClicked,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPressed,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemYellow),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${post.status}',
                    style: TextStyle(
                        color: post.status == 'Rejected' ||
                                post.status == 'Blocked'
                            ? CupertinoColors.systemRed
                            : post.status == 'Pending'
                                ? CupertinoColors.activeOrange
                                : post.status == 'Approved'
                                    ? CupertinoColors.activeGreen
                                    : CupertinoColors.white,
                        fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: onLongPressed,
                    child: const Icon(
                      CupertinoIcons.ellipsis,
                      color: CupertinoColors.white,
                    ),
                  )
                ],
              ),
            ),
            PostCard(
              onLongPress: onLongPressed,
              post: post,
              onClicked: onClicked,
              type: type,
              countryInfo: countryInfo,
            )
          ],
        ),
      ),
    );
  }
}

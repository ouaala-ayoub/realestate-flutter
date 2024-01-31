import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/core/country.dart';
import 'package:svg_flutter/svg.dart';
import '../models/core/post/post.dart';
import '../models/helpers/function_helpers.dart';

enum UseType { home, liked, edit }

class PostCard extends StatelessWidget {
  final Post post;
  final UseType type;
  final bool? loading;
  final bool? isLiked;
  final Country? countryInfo;
  final Function() onClicked;
  final Function()? onLongPress;
  final Function(String)? onHeartClicked;
  const PostCard(
      {this.loading,
      this.isLiked,
      this.onLongPress,
      required this.type,
      this.onHeartClicked,
      this.countryInfo,
      required this.post,
      required this.onClicked,
      super.key});

  @override
  Widget build(BuildContext context) {
    String priceText = formatPrice(post.price);
    if (post.type == 'Rent') {
      priceText += ' / ${post.period}';
    }
    return GestureDetector(
      onLongPress: () => onLongPress?.call(),
      onTap: onClicked,
      child: Card(
        color: const Color(0xFF252525),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4.0,
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              transitionOnUserGestures: true,
              tag: '${post.id}',
              child: Image.network(
                // errorBuilder: (holyContext, error, stackTrace) =>
                //     Center(child: Text('error')),
                post.media!.isNotEmpty ? post.media![0] : '',
                errorBuilder: (context, obj, trace) => const SizedBox(
                  height: 200,
                  child: Icon(
                    CupertinoIcons.eye_slash_fill,
                  ),
                ), // Replace with your image path
                height: 200.0, // Adjust the height as needed
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    priceText,
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.yellow,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        onHeartClicked?.call(post.id!);
                      },
                      child: type == UseType.liked
                          ? const Icon(
                              CupertinoIcons.heart_slash_fill,
                              color: CupertinoColors.white,
                            )
                          : type == UseType.home
                              ? loading == true
                                  ? const Center(
                                      child: CupertinoActivityIndicator(),
                                    )
                                  : isLiked == true
                                      ? const Icon(
                                          CupertinoIcons.heart_slash_fill,
                                          color: CupertinoColors.white,
                                        )
                                      : const Icon(
                                          CupertinoIcons.heart,
                                          color: CupertinoColors.white,
                                        )
                              : Container())
                ],
              ),
            ),
            Container(
              color: Colors.yellow,
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '${post.category}, ${post.type}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 48.0, // Adjust the height as needed
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  countryInfo?.image != null
                      ? SvgPicture.network(
                          countryInfo!.image,
                          height: 32,
                          width: 32,
                        )
                      : const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${post.location?.country}, ${post.location?.city}, ${post.location?.area}',
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        post.features?.length ?? 0,
                        (index) => Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 10),
                          child: SvgPicture.asset(
                            landMarks[post.features?[index]] ?? '',
                            height: 24,
                            width: 32,
                            colorFilter: const ColorFilter.mode(
                              CupertinoColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

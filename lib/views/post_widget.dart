import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate/models/core/country.dart';
import 'package:svg_flutter/svg.dart';
import '../models/core/post/post.dart';
import '../models/helpers/function_helpers.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Country? countryInfo;
  final Function() onClicked;
  const PostCard(
      {this.countryInfo,
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
      onTap: onClicked,
      child: Card(
        color: const Color(0xFF252525),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4.0,
        margin: const EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: false, // Set visibility condition
              child: Card(
                margin: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Out of Order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CupertinoColors.systemRed,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            Hero(
              transitionOnUserGestures: true,
              tag: '${post.id}',
              child: Image.network(
                // errorBuilder: (holyContext, error, stackTrace) =>
                //     Center(child: Text('error')),
                post.media?[0], // Replace with your image path
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
                      onTap: () {}, child: const Icon(CupertinoIcons.heart))
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
            // Add your RecyclerView equivalent widget here
          ],
        ),
      ),
    );
  }
}

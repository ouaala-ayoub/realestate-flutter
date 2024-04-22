import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:realestate/models/core/news.dart';
import 'package:realestate/models/helpers/function_helpers.dart';

class SingleNews extends StatelessWidget {
  final News news;
  const SingleNews({required this.news, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchWebSite(news.link.toString()),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: news.image.toString(),
              height: 300,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${news.title}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              news.content.toString(),
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}

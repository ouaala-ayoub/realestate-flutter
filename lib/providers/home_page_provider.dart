import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/lates_news.dart';
import 'package:realestate/models/core/post/post.dart';
import 'package:realestate/models/helpers/posts_helper.dart';
import 'package:realestate/models/helpers/static_data_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/core/search_params.dart';

class HomePageProvider extends ChangeNotifier {
  final helper = StaticDataHelper();
  final postsHelper = PostsHelper();

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, Post> get pagingController => _pagingController;

  bool newsLoading = false;

  Either<dynamic, LatesNews> news = Right(LatesNews());
  Either<dynamic, List<Post>> posts = const Right([]);

  launchWebSite(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  getPosts(SearchParams searchParams) async {
    try {
      posts = await postsHelper.fetshPosts(
          search: searchParams.search,
          category: searchParams.category,
          city: searchParams.city,
          condition: searchParams.condition,
          country: searchParams.country,
          n: searchParams.n,
          type: searchParams.type,
          features: searchParams.features,
          page: searchParams.page);
      posts.fold((l) {
        logger.e('caught a error in the folding process');
        throw Exception('Unxepected error');
      }, (items) {
        final isLastPage = items.isEmpty;
        logger.d('isLastPage $isLastPage');
        if (isLastPage) {
          // todo fix broken logic
          _pagingController.appendLastPage(items);
        } else {
          // searchParams!.page = (searchParams.page ?? 1) + 1;
          searchParams.page++;
          final nextPageKey = searchParams.page;
          logger.d('nextPageKey $nextPageKey');
          logger.d('appending $items');
          _pagingController.appendPage(items, nextPageKey);
        }
      });
    } catch (e) {
      logger.e(e);
      _pagingController.error = e;
    }
  }

  getNews() async {
    newsLoading = true;
    news = await helper.getNews();
    logger.d(news);
    newsLoading = false;
    notifyListeners();
  }
}

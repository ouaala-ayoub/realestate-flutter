import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/lates_news.dart';
import 'package:realestate/models/core/post/post.dart';
import 'package:realestate/models/helpers/posts_helper.dart';
import 'package:realestate/models/helpers/static_data_helper.dart';

import '../models/core/search_params.dart';

class HomePageProvider extends ChangeNotifier {
  final _helper = StaticDataHelper();
  final _postsHelper = PostsHelper();

  final PagingController<int, PostAndLoading> _pagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, PostAndLoading> get pagingController =>
      _pagingController;

  bool newsLoading = false;
  bool postsLoading = false;

  Either<dynamic, LatesNews> news = Right(LatesNews());
  Either<dynamic, List<Post>> posts = const Right([]);

  getPosts(SearchParams searchParams) async {
    try {
      postsLoading = true;
      posts = await _postsHelper.fetshPosts(
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
        final itemsAndLoadings =
            items.map((post) => PostAndLoading(post, false)).toList();
        if (isLastPage) {
          // todo fix broken logic
          _pagingController.appendLastPage(itemsAndLoadings);
        } else {
          // searchParams!.page = (searchParams.page ?? 1) + 1;
          searchParams.page++;
          final nextPageKey = searchParams.page;
          _pagingController.appendPage(itemsAndLoadings, nextPageKey);
        }
        postsLoading = false;
      });
    } catch (e) {
      logger.e(e);
      _pagingController.error = e;
    }
  }

  setLoading(loading, index) {
    _pagingController.itemList?[index].loading = loading;
    notifyListeners();
  }

  getNews() async {
    newsLoading = true;
    news = await _helper.getNews();
    logger.d(news);
    newsLoading = false;
    notifyListeners();
  }
}

class PostAndLoading {
  Post post;
  bool loading;
  PostAndLoading(this.post, this.loading);
}

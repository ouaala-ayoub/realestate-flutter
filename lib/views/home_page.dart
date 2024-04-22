import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/types.dart';
import 'package:realestate/providers/auth_provider.dart';
import 'package:realestate/providers/home_page_provider.dart';
import 'package:realestate/providers/liked_provider.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/helper_widgets/error_widget.dart';
import 'package:realestate/views/helper_widgets/post_widget.dart';
import 'package:realestate/views/helper_widgets/single_news.dart';
import '../models/helpers/function_helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final homeProvider = context.read<HomePageProvider>();
    final searchProvider = context.read<SearchProvider>();

    searchProvider.getCountries();
    searchProvider.getCategories();
    homeProvider.getNews();
    homeProvider.pagingController.addPageRequestListener((pageKey) {
      homeProvider.getPosts(searchProvider.searchParams);
    });
    // homeProvider.startAutoScroll(300);
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    final url = dotenv.env['WEBSITE_URL'].toString();
    return Consumer<HomePageProvider>(
      builder: (context, homeProvider, child) => Consumer<SearchProvider>(
        builder: (context, searchProvider, child) => CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () => context.push('/settings'),
              child: const Icon(
                CupertinoIcons.settings_solid,
                color: CupertinoColors.white,
                size: 24,
              ),
            ),
            trailing: GestureDetector(
              onTap: () async {
                final shouldSearch = await context.push('/search');
                if (shouldSearch == true) {
                  searchProvider.searchParams.page = 1;
                  homeProvider.pagingController.refresh();
                }
              },
              child: const Icon(
                CupertinoIcons.line_horizontal_3_decrease_circle_fill,
                color: CupertinoColors.white,
                size: 25,
              ),
            ),
            middle: GestureDetector(
              onTap: () async {
                try {
                  launchWebSite(url);
                } catch (e) {
                  logger.e('message');
                }
              },
              child: Text(
                url,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoSegmentedControl<String>(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    pressedColor:
                        CupertinoTheme.of(context).primaryContrastingColor,
                    groupValue: searchProvider.searchParams.type ?? 'All',
                    children: {
                      for (var element in types)
                        element: Text(
                          overflow: TextOverflow.ellipsis,
                          element,
                          style: TextStyle(
                            color:
                                searchProvider.searchParams.type == element ||
                                        (element == 'All' &&
                                            searchProvider.searchParams.type ==
                                                null)
                                    ? CupertinoColors.black
                                    : CupertinoColors.white,
                          ),
                        )
                    },
                    onValueChanged: (String? value) {
                      //todo fix the fast click to another type problem
                      if (!homeProvider.postsLoading) {
                        searchProvider.setSelectedType(value);
                        searchProvider.searchParams.page = 1;
                        homeProvider.pagingController.refresh();
                        logger.i(
                          searchProvider.searchParams.toMap().toString(),
                        );
                      }
                      // homeProvider.getPosts(searchProvider.searchParams);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: chooseButton(
                    'country',
                    () => showActionSheet(context, searchProvider, (country) {
                      searchProvider.setSelectedCountry(country);
                      searchProvider.searchParams.page = 1;
                      homeProvider.pagingController.refresh();
                    }),
                    context,
                    searchProvider.searchParams.country,
                    onClearClicked: () {
                      if (searchProvider.searchParams.country != null) {
                        searchProvider.setSelectedCountry(null);
                        searchProvider.searchParams.page = 1;
                        homeProvider.pagingController.refresh();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CustomScrollView(
                      controller: homeProvider.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () async {
                            searchProvider.refreshParams();
                            homeProvider.pagingController.refresh();
                          },
                        ),
                        SliverToBoxAdapter(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Latest News',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CupertinoTheme.of(buildContext)
                                    .primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: homeProvider.newsLoading
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : homeProvider.news.fold(
                                  (e) => ErrorScreen(
                                    refreshFunction: () async =>
                                        await homeProvider.getNews(),
                                    message: 'Unexpected error',
                                  ),
                                  (news) => SingleChildScrollView(
                                    physics: const PageScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: news
                                          .map(
                                            (singleNews) => SingleNews(
                                              news: singleNews,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: chooseButton(
                              'category',
                              () => showCategoryActionSheet(
                                  context, searchProvider, (category) {
                                searchProvider.setSelectedCategory(category);
                                searchProvider.searchParams.page = 1;
                                homeProvider.pagingController.refresh();
                              }),
                              context,
                              searchProvider.searchParams.category,
                              onClearClicked: () {
                                if (searchProvider.searchParams.category !=
                                    null) {
                                  searchProvider.setSelectedCategory(null);
                                  searchProvider.searchParams.page = 1;
                                  homeProvider.pagingController.refresh();
                                }
                              },
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: CupertinoSearchTextField(
                            onChanged: (query) {
                              if (query.isEmpty) {
                                searchProvider.setSearchQuery(null);
                                searchProvider.searchParams.page = 1;
                                homeProvider.pagingController.refresh();
                              }
                            },
                            onSubmitted: (query) {
                              searchProvider.setSearchQuery(query);
                              searchProvider.searchParams.page = 1;
                              homeProvider.pagingController.refresh();
                            },
                          ),
                        ),
                        PagedSliverList(
                          pagingController: homeProvider.pagingController,
                          builderDelegate:
                              PagedChildBuilderDelegate<PostAndLoading>(
                            firstPageErrorIndicatorBuilder: (context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Something went Wrong!'),
                                const Text('Please try again later'),
                                const SizedBox(
                                  height: 10,
                                ),
                                CupertinoButton.filled(
                                  child: const Text('Refresh'),
                                  onPressed: () {
                                    context
                                        .read<RealestateAuthProvider>()
                                        .fetshLateAuth();
                                    searchProvider.getCountries();
                                    searchProvider.getCategories();
                                    homeProvider.getNews();
                                    homeProvider.getPosts(
                                      searchProvider.searchParams,
                                    );
                                  },
                                ),
                              ],
                            ),
                            noItemsFoundIndicatorBuilder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text('No posts found'),
                                CupertinoButton(
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(CupertinoIcons.refresh),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Refresh'),
                                    ],
                                  ),
                                  onPressed: () {
                                    searchProvider.refreshParams();
                                    homeProvider.pagingController.refresh();
                                  },
                                )
                              ],
                            ),
                            firstPageProgressIndicatorBuilder: (context) {
                              return const CupertinoActivityIndicator();
                            },
                            newPageProgressIndicatorBuilder: (context) =>
                                const CupertinoActivityIndicator(),
                            itemBuilder: (context, item, index) {
                              final country = searchProvider.countries
                                  .fold((l) => null, (r) {
                                try {
                                  return r.firstWhere((element) =>
                                      element.name ==
                                      item.post.location?.country);
                                } catch (e) {
                                  logger.e('element not found');
                                  return null;
                                }
                              });
                              return Consumer<RealestateAuthProvider>(
                                builder: (context, authProvider, _) {
                                  final liked = authProvider.auth?.fold(
                                    (l) => null,
                                    (user) =>
                                        user.likes?.contains(item.post.id),
                                  );

                                  return PostCard(
                                    type: UseType.home,
                                    loading: item.loading,
                                    isLiked: liked == true,
                                    countryInfo: country,
                                    post: item.post,
                                    //todo fix this shit logic
                                    onHeartClicked: (postId) {
                                      if (item.loading) {
                                        return;
                                      }
                                      if (liked == null) {
                                        //show a dialog
                                        logger.i('not logged in');
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                            title: const Text('Unauthorized'),
                                            content: const Text(
                                              'Please login first !',
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () => context.pop(),
                                                child: const Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                    color:
                                                        CupertinoColors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      } else if (liked == false) {
                                        homeProvider.setLoading(true, index);
                                        authProvider.like(
                                          postId,
                                          onSuccess: () {
                                            homeProvider.setLoading(
                                                false, index);
                                            authProvider.fetshAuth();
                                            authProvider.auth?.fold(
                                              (l) => null,
                                              (user) => context
                                                  .read<LikedPageProvider>()
                                                  .fetshLikedPosts(user.id),
                                            );
                                          },
                                        );
                                      } else if (liked == true) {
                                        homeProvider.setLoading(true, index);
                                        authProvider.unlike(postId,
                                            onSuccess: () {
                                          homeProvider.setLoading(false, index);
                                          authProvider.fetshAuth();
                                          authProvider.auth?.fold(
                                            (l) => null,
                                            (user) => context
                                                .read<LikedPageProvider>()
                                                .fetshLikedPosts(user.id),
                                          );
                                        });
                                      }
                                    },
                                    onClicked: () async {
                                      final liked = await context.push(
                                        '/postPage/${item.post.id}',
                                        extra: {
                                          'post': item.post,
                                          'country_info': country
                                        },
                                      );
                                      logger.d(liked);
                                      if (liked == 'liked') {
                                        item.post.likes = item.post.likes! + 1;
                                      }
                                      if (liked == 'disliked') {
                                        item.post.likes = item.post.likes! - 1;
                                      }
                                      logger.i(item.post.likes);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

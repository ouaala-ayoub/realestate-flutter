import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/types.dart';
import 'package:realestate/providers/home_page_provider.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/post_widget.dart';
import '../models/core/post/post.dart';
import '../models/helpers/function_helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    const url = 'https://realestatefy.vercel.app';
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
                    homeProvider.launchWebSite(url);
                  },
                  child: const Text(url))),
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoSegmentedControl<String>(
                  //todo the selected value should get set in the group
                  groupValue: searchProvider.searchParams.type ?? 'All',

                  children: {
                    for (var element in types)
                      element: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          element,
                          style: const TextStyle(color: CupertinoColors.white),
                        ),
                      )
                  },
                  onValueChanged: (String? value) {
                    logger.i(value);
                    searchProvider.setSelectedType(value);
                    searchProvider.searchParams.page = 1;
                    homeProvider.pagingController.refresh();
                  },
                ),
              ),
              chooseButton(
                  'country',
                  () => showActionSheet(context, searchProvider, (country) {
                        searchProvider.searchParams.page = 1;
                        homeProvider.pagingController.refresh();
                      }),
                  context,
                  searchProvider),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Latest News',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoTheme.of(buildContext)
                                      .primaryColor),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        homeProvider.newsLoading
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : homeProvider.news.fold(
                                (e) => const Center(
                                      child: Text('Unexpected error'),
                                    ),
                                (news) => ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 1,
                                    // itemCount: news.length,
                                    itemBuilder: (context, index) {
                                      logger.i('building $news');
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            'https://realestatefy.vercel.app/${news.image}',
                                            // loadingBuilder: (context, child,
                                            //         loadingProgress) =>
                                            //     CupertinoActivityIndicator(),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text('${news.title}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            news.contents!.join('\n'),
                                            style:
                                                const TextStyle(fontSize: 14),
                                          )
                                        ],
                                      );
                                    })),
                        const SizedBox(
                          height: 10,
                        ),
                        chooseButton(
                            'category',
                            () => showCategoryActionSheet(
                                    context, searchProvider, (category) {
                                  searchProvider.searchParams.page = 1;
                                  homeProvider.pagingController.refresh();
                                }),
                            context,
                            searchProvider),
                        const CupertinoSearchTextField(),
                        PagedListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          pagingController: homeProvider.pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Post>(
                              firstPageProgressIndicatorBuilder: (context) =>
                                  const CupertinoActivityIndicator(),
                              newPageProgressIndicatorBuilder: (context) =>
                                  const CupertinoActivityIndicator(),
                              itemBuilder: (context, item, index) {
                                final country = searchProvider.countries
                                    .fold((l) => null, (r) {
                                  try {
                                    return r.firstWhere((element) =>
                                        element.name == item.location?.country);
                                  } catch (e) {
                                    logger.e('element not found');
                                    return null;
                                  }
                                });
                                return PostCard(
                                  type: UseType.home,
                                  countryInfo: country,
                                  post: item,
                                  onHeartClicked: (postId) {},
                                  onClicked: () {
                                    context.push('/postPage', extra: item);
                                  },
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/core/types.dart';
import 'package:realestate/providers/auth_provider.dart';
import 'package:realestate/providers/liked_provider.dart';
import 'package:realestate/providers/post_page_provider.dart';
import 'package:realestate/views/error_widget.dart';
import 'package:realestate/views/filter_page.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/helpers/function_helpers.dart';
import 'package:share_plus/share_plus.dart';

class PostPage extends StatefulWidget {
  final String postId;
  const PostPage({required this.postId, super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool loading = false;
  int likes = 0;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PostPageProvider>();
    // provider.fetshPost(widget.postId);
    provider.post.fold((l) {
      likes = 0;
    }, (post) {
      likes = post.likes ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        final provider = context.read<PostPageProvider>();

        provider.post.fold((l) {
          context.pop();
        }, (post) {
          final liked = likes > post.likes!
              ? 'liked'
              : likes < post.likes!
                  ? 'disliked'
                  : null;

          logger.i(liked);
          context.pop(liked);
        });
      },
      child: Consumer<PostPageProvider>(
        builder: (context, provider, _) => provider.post.fold(
            (l) => ErrorScreen(
                  refreshFunction: provider.fetshPost(widget.postId),
                  message: 'Unexpected error',
                ), (post) {
          String priceText = formatPrice(post.price);
          if (post.type == 'Rent') {
            priceText += ' / ${post.period}';
          }
          final phone = 'tel:${post.contact?.code}${post.contact?.phone}';
          final authProvider = context.watch<RealestateAuthProvider>();
          if (provider.firstTime) {
            provider.fetshUser(post.owner);
            provider.firstTime = false;
          }
          return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  middle: const Text('Post page'),
                  trailing: GestureDetector(
                    child: const Icon(CupertinoIcons.flag,
                        size: 24, color: CupertinoColors.white),
                    onTap: () => showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                  isDestructiveAction: true,
                                  child: const Text(
                                    'Report',
                                  ),
                                  onPressed: () {
                                    context.pop();
                                    context.push('/report/${post.id}');
                                  },
                                )
                              ],
                            )),
                  )),
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: () async {
                        await provider.fetshPost(widget.postId);
                      },
                    ),
                    SliverToBoxAdapter(
                      child: Hero(
                        tag: post.id!,
                        child: SizedBox(
                          height: 300,
                          child: PhotoViewGallery.builder(
                            gaplessPlayback: true,
                            itemCount: post.media?.length ?? 0,
                            builder: (context, index) =>
                                PhotoViewGalleryPageOptions(
                              imageProvider: CachedNetworkImageProvider(
                                post.media![index],
                              ),
                              initialScale: PhotoViewComputedScale.contained,
                            ),
                            loadingBuilder: (context, event) => Center(
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // child: Hero(
                      //   tag: '${post.id}',
                      //   child: Image.network(
                      //     post.media!.isNotEmpty
                      //         ? post.media![0]
                      //         : '', // Replace with your image path
                      //     height: 300, // Adjust the height as needed
                      //     fit: BoxFit.fitWidth,
                      //     errorBuilder: (context, obj, trace) => const SizedBox(
                      //       height: 300,
                      //       child: Icon(
                      //         CupertinoIcons.eye_slash_fill,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    //todo change color
                    SliverToBoxAdapter(
                      child: richTextIconRow(
                        '${post.type}',
                        '${post.category}',
                        CupertinoColors.white,
                        Consumer<RealestateAuthProvider>(
                            builder: (context, provider, _) => loading
                                ? const Center(
                                    child: CupertinoActivityIndicator(),
                                  )
                                : provider.loading
                                    ? const Center(
                                        child: CupertinoActivityIndicator(),
                                      )
                                    : provider.auth!.fold((l) {
                                        logger.i('you need to login first');
                                        return const Icon(CupertinoIcons.heart);
                                      },
                                        (user) => user.likes
                                                    ?.contains(post.id) ==
                                                true
                                            ? const Icon(
                                                CupertinoIcons.heart_slash_fill)
                                            : const Icon(
                                                CupertinoIcons.heart))),
                        '$likes',
                        () {
                          loading
                              ? logger.i('loading')
                              : context
                                  .read<RealestateAuthProvider>()
                                  .auth!
                                  .fold((l) {
                                  logger.i('you need to login first');
                                  //todo maybe go to login page
                                }, (user) {
                                  if (user.likes?.contains(post.id) == true) {
                                    logger.i('unliking');
                                    setState(() {
                                      loading = true;
                                    });
                                    context
                                        .read<RealestateAuthProvider>()
                                        .unlike(post.id, onSuccess: () {
                                      authProvider.fetshAuth();
                                      context
                                          .read<LikedPageProvider>()
                                          .fetshLikedPosts(user.id);
                                      setState(() {
                                        loading = false;
                                        if (likes > 0) {
                                          likes--;
                                        }
                                      });
                                    });
                                  } else {
                                    logger.i('liking');
                                    setState(() {
                                      loading = true;
                                    });
                                    context
                                        .read<RealestateAuthProvider>()
                                        .like(post.id, onSuccess: () {
                                      authProvider.fetshAuth();
                                      context
                                          .read<LikedPageProvider>()
                                          .fetshLikedPosts(user.id);
                                      setState(() {
                                        loading = false;
                                        likes++;
                                      });
                                    });
                                  }
                                });
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: textIconRow(
                        priceText,
                        CupertinoColors.systemYellow,
                        const Icon(CupertinoIcons.share),
                        'Share',
                        () async {
                          final link =
                              'https://realestatefy.vercel.app/posts/${post.id}';

                          Share.share(
                              'I thought you might find this post interesting: $link',
                              subject: 'Check out this post');
                        },
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate([
                        loacationText(
                            MapEntry('Country', post.location?.country)),
                        loacationText(MapEntry('City', post.location?.city)),
                        loacationText(MapEntry('Area', post.location?.area)),
                        // Add other widgets for details section...
                      ]),
                    ),
                    const SliverToBoxAdapter(
                      child: TitleWidget(text: 'Details :'),
                    ),

                    // Continue with other SliverList or SliverGrid widgets for different sections
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    post.features?.isNotEmpty == true
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: featureMethod(
                                  SvgPicture.asset(
                                    landMarks[post.features![index]]!,
                                    height: 24,
                                    width: 24,
                                    colorFilter: const ColorFilter.mode(
                                        CupertinoColors.white, BlendMode.srcIn),
                                    placeholderBuilder: (context) => const Icon(
                                      CupertinoIcons.eye_slash_fill,
                                      size: 24,
                                    ),
                                  ),
                                  post.features?[index],
                                ),
                              ),
                              childCount: post.features?.length ?? 0,
                            ),
                          )
                        : const SliverToBoxAdapter(
                            child: Center(
                              child: Text('No Details'),
                            ),
                          ),
                    const SliverToBoxAdapter(
                        child: TitleWidget(text: 'More :')),

                    detailedCategories.contains(post.category)
                        ? SliverList.list(children: [
                            moreTextMethod(
                                'Property Condition : ', post.condition),
                            moreTextMethod('Number of Rooms : ', post.rooms),
                            moreTextMethod(
                                'Number of Bathrooms : ', post.bathrooms),
                            moreTextMethod(
                                'Space : ',
                                post.space != null
                                    ? '${post.space} m² = ${squareMetersToSquareFeet(double.parse(post.space.toString()))} foot²'
                                    : 'Unavailable'),
                          ])
                        : const SliverToBoxAdapter(
                            child: Center(child: Text('Unavailable'))),
                    //todo add meter
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: TitleWidget(text: 'Description :'),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(post.description ?? 'Unavailable'),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: TitleWidget(text: 'Owner : '),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Consumer<PostPageProvider>(
                          builder: (context, provider, consumerWidget) =>
                              provider.loading
                                  ? const Center(
                                      child: CupertinoActivityIndicator(),
                                    )
                                  : provider.user != null
                                      ? provider.user!.fold(
                                          (l) => const Center(
                                            child: Text('User not Found'),
                                          ),
                                          (user) => Column(
                                            children: [
                                              Row(
                                                children: [
                                                  user.image != null
                                                      ? Image.network(
                                                          user.image!,
                                                          height: 100,
                                                          width: 100,
                                                        )
                                                      : const Icon(
                                                          CupertinoIcons
                                                              .person_alt_circle,
                                                          size: 100,
                                                          color: CupertinoColors
                                                              .white,
                                                        ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          user.name ??
                                                              'Unavailable',
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const Text(
                                                            'On realestatefy since'),
                                                        Text(user.createdAt
                                                            .toString()
                                                            .split(' ')[0]),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  CupertinoButton(
                                                    child: featureMethod(
                                                      const Icon(
                                                          CupertinoIcons.phone),
                                                      'Call',
                                                    ),
                                                    onPressed: () async {
                                                      if (post.contact?.type ==
                                                              'Call' ||
                                                          post.contact?.type ==
                                                              'Both') {
                                                        try {
                                                          final phone =
                                                              'tel:${post.contact?.code}${post.contact?.phone}';

                                                          logger.d(phone);
                                                          final call =
                                                              Uri.parse(phone);
                                                          if (await canLaunchUrl(
                                                              call)) {
                                                            launchUrl(call);
                                                          } else {
                                                            throw 'Could not launch $call';
                                                          }
                                                        } catch (e) {
                                                          logger.e(e);
                                                          if (context.mounted) {
                                                            showCupertinoModalPopup(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CupertinoActionSheet(
                                                                  title: const Text(
                                                                      'Failure'),
                                                                  message:
                                                                      const Text(
                                                                          "Can't pass the call!"),
                                                                  actions: [
                                                                    CupertinoActionSheetAction(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        }
                                                      }
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: featureMethod(
                                                      SvgPicture.asset(
                                                        'assets/icons/whatsapp.svg',
                                                        height: 24,
                                                        width: 24,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                          CupertinoColors
                                                              .activeGreen,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                      'Whatsapp',
                                                    ),
                                                    onPressed: () {
                                                      if (post.contact?.type ==
                                                              'Call' ||
                                                          post.contact?.type ==
                                                              'Both') {
                                                        whatsapp(
                                                          phone,
                                                          () =>
                                                              showCupertinoModalPopup(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CupertinoActionSheet(
                                                                title: const Text(
                                                                    'Failure',
                                                                    style: TextStyle(
                                                                        color: CupertinoColors
                                                                            .white)),
                                                                message:
                                                                    const Text(
                                                                  'WhatsApp is not installed in this device',
                                                                  style: TextStyle(
                                                                      color: CupertinoColors
                                                                          .white),
                                                                ),
                                                                actions: [
                                                                  CupertinoActionSheetAction(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                            'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : const Center(
                                          child: Text('Unexpected Error'),
                                        ),
                        ),
                      ),
                    ),
                  ],
                ),
              )));
        }),
      ),
    );
  }

  Padding moreTextMethod(String initial, value) => Padding(
        padding: const EdgeInsets.only(left: 5),
        child: RichText(
          text: TextSpan(
              text: initial,
              style: const TextStyle(fontSize: 16),
              children: [
                TextSpan(
                    text: value != null ? value.toString() : 'Unavailable',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18))
              ]),
          maxLines: 1,
        ),
      );

  RichText featureMethod(icon, String text) {
    return RichText(
        maxLines: 1,
        text: TextSpan(children: [
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: icon,
              )),
          TextSpan(text: text, style: const TextStyle(fontSize: 16))
        ]));
  }

  RichText loacationText(MapEntry<String, String?> map) {
    return RichText(
        text: TextSpan(text: '${map.key} : ', children: [
      TextSpan(
          text: map.value ?? '-',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    ]));
  }

  Row richTextIconRow(String text1, String text2, Color textColor, Widget icon,
      String iconText, Function() onIconTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 22, color: textColor),
                children: [
              TextSpan(
                  text: '$text1\n',
                  style: const TextStyle(color: CupertinoColors.systemYellow)),
              TextSpan(
                text: text2,
              )
            ])),
        GestureDetector(
          onTap: onIconTap,
          child: RichText(
              maxLines: 1,
              text: TextSpan(children: [
                WidgetSpan(child: icon, alignment: PlaceholderAlignment.middle),
                TextSpan(text: iconText),
              ])),
        ),
      ],
    );
  }

  Row textIconRow(String text, Color textColor, Widget icon, String iconText,
      Function() onIconTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        GestureDetector(
          onTap: onIconTap,
          child: RichText(
              maxLines: 1,
              text: TextSpan(children: [
                WidgetSpan(child: icon, alignment: PlaceholderAlignment.middle),
                TextSpan(text: iconText),
              ])),
        ),
      ],
    );
  }
}

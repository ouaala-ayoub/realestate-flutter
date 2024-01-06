import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/icons.dart';
import 'package:realestate/providers/post_page_provider.dart';
import 'package:realestate/views/filter_page.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/core/post/post.dart';
import '../models/helpers/function_helpers.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({required this.post, super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostPageProvider>().fetshUser(widget.post.owner);
  }

  @override
  Widget build(BuildContext context) {
    String priceText = formatPrice(widget.post.price);
    if (widget.post.type == 'Rent') {
      priceText += ' / ${widget.post.period}';
    }
    final phone =
        'tel:${widget.post.contact?.code}${widget.post.contact?.phone}';
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: const Text('Post page'),
            trailing: GestureDetector(
              child: const Icon(CupertinoIcons.ellipsis),
              onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                        title: const Text('More',
                            style: TextStyle(color: CupertinoColors.white)),
                        actions: [
                          CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            child: const Text(
                              'Report',
                            ),
                            onPressed: () {
                              context.pop();
                              context.push('/report/${widget.post.id}');
                            },
                          )
                        ],
                      )),
            )),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Hero(
                    tag: '${widget.post.id}',
                    child: Image.network(
                      widget.post.media?[0], // Replace with your image path
                      height: 300, // Adjust the height as needed
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textIconRow(
                    '${widget.post.category}, ${widget.post.type}',
                    CupertinoColors.white,
                    CupertinoIcons.heart,
                    '${widget.post.likes}',
                    () {}),
                const SizedBox(
                  height: 10,
                ),
                textIconRow(priceText, CupertinoColors.systemYellow,
                    CupertinoIcons.share, 'Share', () {}),
                const SizedBox(
                  height: 10,
                ),
                loacationText(
                    MapEntry('Country', widget.post.location?.country)),
                loacationText(MapEntry('City', widget.post.location?.city)),
                loacationText(MapEntry('Area', widget.post.location?.area)),
                const SizedBox(
                  height: 10,
                ),
                const TitleWidget(text: 'Details :'),
                const SizedBox(
                  height: 10,
                ),
                widget.post.features?.isNotEmpty == true
                    ? ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 8,
                            ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.post.features?.length ?? 0,
                        itemBuilder: (context, index) => featureMethod(
                            Icon(featureIcons[widget.post.features?[index]]),
                            widget.post.features?[index]))
                    : const Center(
                        child: Text('No features'),
                      ),
                const SizedBox(
                  height: 10,
                ),
                const TitleWidget(text: 'More :'),
                const SizedBox(
                  height: 10,
                ),
                moreTextMethod('Proprety Condition : ', widget.post.condition),
                const SizedBox(
                  height: 5,
                ),
                moreTextMethod('Number of Rooms : ', widget.post.rooms),
                const SizedBox(
                  height: 5,
                ),
                moreTextMethod('Number of Bathrooms : ', widget.post.bathrooms),
                const SizedBox(
                  height: 5,
                ),
                widget.post.floors != null && widget.post.floorNumber != null
                    ? moreTextMethod('Floor Info : ',
                        'Floor n°${widget.post.floorNumber} Out of ${widget.post.floors}')
                    : moreTextMethod('Floor Info : ', 'Unavailable'),
                const SizedBox(
                  height: 5,
                ),
                widget.post.space != null
                    ? moreTextMethod('Space : ',
                        '${widget.post.space} m² = ${squareMetersToSquareFeet(double.parse(widget.post.space.toString()))} foot²')
                    : moreTextMethod('Space : ', 'Unavailable'),
                const SizedBox(
                  height: 10,
                ),
                const TitleWidget(text: 'Description'),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(widget.post.description ?? 'Unavailable')),
                const SizedBox(
                  height: 10,
                ),
                const TitleWidget(text: 'Owner : '),
                const SizedBox(
                  height: 10,
                ),
                Padding(
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
                                                          .split(' ')[0])
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CupertinoButton(
                                                    child: featureMethod(
                                                        const Icon(
                                                            CupertinoIcons
                                                                .phone),
                                                        'Call'),
                                                    onPressed: () async {
                                                      if (widget.post.contact
                                                                  ?.type ==
                                                              'Call' ||
                                                          widget.post.contact
                                                                  ?.type ==
                                                              'Both') {
                                                        try {
                                                          final phone =
                                                              'tel:${widget.post.contact?.code}${widget.post.contact?.phone}';

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
                                                    }),
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
                                                                    BlendMode
                                                                        .srcIn)),
                                                        'Whatsapp'),
                                                    onPressed: () {
                                                      if (widget.post.contact
                                                                  ?.type ==
                                                              'Call' ||
                                                          widget.post.contact
                                                                  ?.type ==
                                                              'Both') {
                                                        whatsapp(
                                                            phone,
                                                            () =>
                                                                showCupertinoModalPopup(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return CupertinoActionSheet(
                                                                      title: const Text(
                                                                          'Failure',
                                                                          style:
                                                                              TextStyle(color: CupertinoColors.white)),
                                                                      message:
                                                                          const Text(
                                                                        'WhatsApp is not installed in this device',
                                                                        style: TextStyle(
                                                                            color:
                                                                                CupertinoColors.white),
                                                                      ),
                                                                      actions: [
                                                                        CupertinoActionSheetAction(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('OK'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ));
                                                      }
                                                    })
                                              ],
                                            )
                                          ],
                                        ))
                                : const Center(
                                    child: Text('Unexpected Error'),
                                  ),
                  ),
                )
              ],
            )
          ],
        ));
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

  Row textIconRow(String text, Color textColor, IconData icon, String iconText,
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
                WidgetSpan(
                    child: Icon(icon), alignment: PlaceholderAlignment.middle),
                TextSpan(text: iconText),
              ])),
        ),
      ],
    );
  }
}

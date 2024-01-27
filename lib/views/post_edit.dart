import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/core/types.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/post_edit_provider.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/double_text_field.dart';
import 'package:realestate/views/error_widget.dart';
import 'package:realestate/views/feature_widget.dart';
import 'package:svg_flutter/svg.dart';

class PostEditPage extends StatefulWidget {
  final String postId;
  const PostEditPage({required this.postId, super.key});

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostEditProvider>().fetshPost(widget.postId);
  }

  @override
  Widget build(BuildContext buildContext) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Post Edit'),
      ),
      child: Consumer<PostEditProvider>(
          builder: (context, provider, _) => provider.loading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : provider.post.fold(
                  (l) => ErrorScreen(
                      refreshFunction: provider.fetshPost(widget.postId),
                      message: 'Error getting post data'), (post) {
                  if (provider.firstTime) {
                    provider.postBuilder = post.toMap()
                      ..removeWhere((key, value) => value == null);
                    provider.initialiseBuilder();
                    logger.i(provider.postBuilder);
                    provider.firstTime = false;
                  }
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                //todo add error texts
                                CupertinoButton(
                                  onPressed: () =>
                                      showEditPicker(context, availableTypes,
                                          onClicked: (value) {
                                    provider.setPostBuilderField('type', value);
                                    if (value != 'Rent') {
                                      provider.setPostBuilderField(
                                          'period', null);
                                    }
                                  }),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Propriety Type : ',
                                        style: TextStyle(
                                            color: CupertinoColors.white),
                                      ),
                                      Text(provider.postBuilder['type']),
                                    ],
                                  ),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    if (provider.postBuilder['type'] ==
                                        'Rent') {
                                      showPicker(
                                          context, null, periods, 'period',
                                          onClicked: (value) =>
                                              provider.setPostBuilderField(
                                                  'period', value));
                                    } else {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                                actions: [
                                                  CupertinoDialogAction(
                                                      onPressed: () =>
                                                          context.pop(),
                                                      isDestructiveAction: true,
                                                      child:
                                                          const Text('Cancel'))
                                                ],
                                                content: const Text(
                                                  'Property type is not Rent',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ));
                                    }
                                  },
                                  child: Text(provider.postBuilder['period'] ??
                                      'Choose a Period'),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CupertinoFormRow(
                                  padding: const EdgeInsets.all(0),
                                  error:
                                      provider.postBuilder['price'].text.isEmpty
                                          ? const Text('Please enter the price')
                                          : null,
                                  child: CupertinoTextField(
                                    prefix: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: smallTitle('Price :')),
                                    placeholder: 'Price',
                                    controller: provider.postBuilder['price'],
                                    onChanged: (value) => provider.notifty(),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                smallTitle('Contact Informations :'),
                                CupertinoFormRow(
                                  padding: const EdgeInsets.all(0),
                                  error: provider
                                          .postBuilder['contact']['phone']
                                          .text
                                          .isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Text(
                                              'Please enter your phone number'),
                                        )
                                      : null,
                                  child: Row(
                                    children: [
                                      CupertinoButton(
                                        child: flagAndCode(provider),
                                        onPressed: () {
                                          final searchProvider =
                                              context.read<SearchProvider>();

                                          showActionSheet(
                                              context, searchProvider,
                                              (country) {
                                            provider.postBuilder['phoneFlag'] =
                                                country.image;

                                            provider.postBuilder['contact']
                                                ['code'] = country.dialCode;
                                            provider.notifty();

                                            // context.pop();
                                          }, showCode: true);
                                        },
                                      ),
                                      Flexible(
                                        child: CupertinoTextField(
                                          maxLength: 15,
                                          onChanged: (value) =>
                                              provider.notifty(),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          placeholder: 'Phone Number',
                                          controller: provider
                                              .postBuilder['contact']['phone'],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                CupertinoFormRow(
                                  padding: const EdgeInsets.all(0),
                                  error: provider.postBuilder['contact']
                                              ['type'] ==
                                          null
                                      ? const Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Text(
                                              'Choose atleast one communication method'),
                                        )
                                      : null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.phone,
                                            size: 24,
                                          ),
                                          CupertinoSwitch(
                                            value: provider.postBuilder['call'],
                                            onChanged: (checked) =>
                                                provider.handleContactType(
                                                    'call', checked),
                                          )
                                        ],
                                      ),
                                      Row(children: [
                                        SvgPicture.asset(
                                          'assets/icons/whatsapp.svg',
                                          height: 24,
                                          width: 24,
                                          colorFilter: const ColorFilter.mode(
                                            CupertinoColors.activeGreen,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CupertinoSwitch(
                                            value: provider
                                                .postBuilder['whatsapp'],
                                            onChanged: (checked) =>
                                                provider.handleContactType(
                                                    'whatsapp', checked))
                                      ]),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                smallTitle('Location :'),
                                chooseButton(
                                    'country',
                                    () => showActionSheet(context,
                                            context.read<SearchProvider>(),
                                            (country) {
                                          provider.postBuilder['location']
                                              ['country'] = country.name;
                                          provider.notifty();
                                        }),
                                    context,
                                    provider.postBuilder['location']
                                        ['country']),
                                CupertinoFormRow(
                                  padding: const EdgeInsets.all(0),
                                  error: provider
                                          .postBuilder['location']['city']
                                          .text
                                          .isEmpty
                                      ? const Text('Enter a city')
                                      : null,
                                  child: CupertinoTextField(
                                    onChanged: (value) => provider.notifty(),
                                    prefix: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: smallTitle('City : '),
                                    ),
                                    placeholder: 'City',
                                    controller: provider.postBuilder['location']
                                        ['city'],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CupertinoTextField(
                                  prefix: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: smallTitle('Area :'),
                                  ),
                                  placeholder: 'Area',
                                  controller: provider.postBuilder['location']
                                      ['area'],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CupertinoFormRow(
                                  padding: const EdgeInsets.all(0),
                                  error: provider.postBuilder['description']
                                          .text.isEmpty
                                      ? const Text(
                                          'Please provide a description')
                                      : null,
                                  child: CupertinoTextField(
                                    prefix: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: smallTitle('Description :'),
                                    ),
                                    placeholder: 'Description',
                                    controller:
                                        provider.postBuilder['description'],
                                    onChanged: (value) => provider.notifty(),
                                    minLines: 5,
                                    maxLines: 5,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                detailedCategories.contains(
                                        provider.postBuilder['category'])
                                    ? Column(children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        smallTitle(
                                            'Additional Informations : '),
                                        Center(
                                          child: CupertinoButton(
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    'Property Condition  ',
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .white),
                                                  ),
                                                  Text(provider.postBuilder[
                                                          'condition'] ??
                                                      'Choose')
                                                ]),
                                            onPressed: () {
                                              showEditPicker(
                                                  context, conditions,
                                                  onClicked: (value) {
                                                provider.setPostBuilderField(
                                                    'condition', value);
                                              });
                                            },
                                          ),
                                        ),
                                        CupertinoFormRow(
                                          padding: const EdgeInsets.all(0),
                                          error: provider.postBuilder['rooms']
                                                  .text.isEmpty
                                              ? const Text('required *')
                                              : null,
                                          child: CupertinoTextField(
                                            onChanged: (value) =>
                                                provider.notifty(),
                                            prefix: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: smallTitle(
                                                      'Number of Rooms : '),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                            placeholder: 'Number of rooms',
                                            controller:
                                                provider.postBuilder['rooms'],
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        CupertinoFormRow(
                                          padding: const EdgeInsets.all(0),
                                          error: provider
                                                  .postBuilder['bathrooms']
                                                  .text
                                                  .isEmpty
                                              ? const Text('required *')
                                              : null,
                                          child: CupertinoTextField(
                                            prefix: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: smallTitle(
                                                  'Number of Bathrooms :'),
                                            ),
                                            placeholder: 'Number of Bathrooms',
                                            controller: provider
                                                .postBuilder['bathrooms'],
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        smallTitle('Floor Number :'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CupertinoFormRow(
                                          padding: const EdgeInsets.all(0),
                                          error: provider
                                                      .postBuilder[
                                                          'floorNumber']
                                                      .text
                                                      .isEmpty ||
                                                  provider.postBuilder['floors']
                                                      .text.isEmpty
                                              ? const Text('required *')
                                              : null,
                                          child: DoubleTextField(
                                              onChanged1: (v) =>
                                                  provider.notifty(),
                                              onChanged2: (v) =>
                                                  provider.notifty(),
                                              values: const [
                                                'Floor Number',
                                                'Out of',
                                                'Floors in the building'
                                              ],
                                              controllers: [
                                                provider
                                                    .postBuilder['floorNumber'],
                                                provider.postBuilder['floors'],
                                              ]),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        smallTitle('Space :'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DoubleTextField(
                                          values: const [
                                            'm²',
                                            '    \u21C4    ',
                                            'foot²'
                                          ],
                                          controllers: [
                                            provider.postBuilder['space'],
                                            provider.postBuilder['foot2'],
                                          ],
                                          onChanged1: (value) =>
                                              provider.updateSquareFeet(value),
                                          onChanged2: (value) => provider
                                              .updateSquareMeters(value),
                                        ),
                                        smallTitle('Landmarks/ Facilities :'),
                                        Center(
                                          child: CupertinoButton(
                                            child:
                                                const Text('Modify features'),
                                            onPressed: () {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (context) =>
                                                          CupertinoActionSheet(
                                                            title: const Text(
                                                              'Please Check the features your property have !',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color:
                                                                      CupertinoColors
                                                                          .white),
                                                            ),
                                                            cancelButton:
                                                                CupertinoButton(
                                                                    child:
                                                                        const Text(
                                                                      'Done',
                                                                      style: TextStyle(
                                                                          color:
                                                                              CupertinoColors.activeGreen),
                                                                    ),
                                                                    onPressed: () =>
                                                                        context.pop(
                                                                            ())),
                                                            actions: landMarks
                                                                .entries
                                                                .map((entry) => FeatureWidget(
                                                                    isChecked: provider.postBuilder[
                                                                            'features']
                                                                        .contains(entry
                                                                            .key),
                                                                    svgPath: entry
                                                                        .value,
                                                                    featureText:
                                                                        entry
                                                                            .key,
                                                                    onChecked: (checked) =>
                                                                        provider
                                                                            .handleFeature(entry.key)))
                                                                .toList(),
                                                          ));
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ])
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          CupertinoButton.filled(
                              child: const Text('Update'),
                              onPressed: () {
                                if (!provider.canUpdate(provider.postBuilder)) {
                                  showInformativeDialog(context,
                                      'All informations are required !');
                                } else {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoAlertDialog(
                                            title: const Text('Confirmation !'),
                                            content: const Text(
                                                'Are you sure you want to proceed with the modifications ?'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: CupertinoColors
                                                          .white),
                                                ),
                                                onPressed: () {
                                                  context.pop();
                                                  provider.submitUpdate(
                                                      onSuccess: () {
                                                    showInformativeDialog(
                                                        buildContext,
                                                        'Informations Updated Successfully');
                                                  }, onFail: (e) {
                                                    logger
                                                        .e('error updating $e');
                                                    showInformativeDialog(
                                                        buildContext,
                                                        'Unexpected error while tring to update');
                                                  });
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                child: const Text('Cancel'),
                                                onPressed: () => context.pop(),
                                              )
                                            ],
                                          ));
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  );
                })),
    );
  }

  Future<dynamic> showInformativeDialog(
      BuildContext buildContext, String text) {
    return showCupertinoDialog(
        context: buildContext,
        builder: (context) => CupertinoAlertDialog(
              content: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Ok'),
                  onPressed: () => context.pop(),
                ),
              ],
            ));
  }

  Align smallTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: CupertinoColors.systemYellow),
      ),
    );
  }

  Row flagAndCode(PostEditProvider provider) {
    return Row(
      children: [
        SvgPicture.network(
          provider.postBuilder['phoneFlag'] ?? '',
          height: 24,
          width: 24,
          placeholderBuilder: (context) => const Icon(
            CupertinoIcons.eye_slash_fill,
            size: 24,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(provider.postBuilder['contact']['code'] ?? 'phone code'),
      ],
    );
  }

  showTypePicker(PostEditProvider provider) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: availableTypes
                  .map((type) => GestureDetector(
                        onTap: () {
                          provider.setPostBuilderField('type', type);
                          context.pop();
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(type)),
                      ))
                  .toList(),
            ));
  }
}

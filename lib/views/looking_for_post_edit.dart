import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/looking_for_edit_provider.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/helper_widgets/error_widget.dart';
import 'package:svg_flutter/svg_flutter.dart';

class LookingForPostEdit extends StatefulWidget {
  final String postId;
  const LookingForPostEdit({required this.postId, super.key});

  @override
  State<LookingForPostEdit> createState() => _LookingForPostEditState();
}

class _LookingForPostEditState extends State<LookingForPostEdit> {
  @override
  void initState() {
    super.initState();
    context.read<LookingForPostEditProvider>().fetshPost(widget.postId);
  }

  @override
  Widget build(BuildContext buildContext) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Post Edit')),
      child: SafeArea(
          child: Consumer<LookingForPostEditProvider>(
        builder: (context, provider, child) => provider.loading
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
                  final country = context.read<SearchProvider>().countries.fold(
                      (l) => null,
                      (countries) => countries.firstWhere((element) =>
                          provider.postBuilder['contact']['code'] ==
                          element.dialCode));
                  provider.initialiseBuilder(countryFlag: country?.image);
                  logger.i(provider.postBuilder);
                  provider.firstTime = false;
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(children: [
                      Expanded(
                        child: ListView(
                          children: [
                            chooseButton(
                                'country',
                                () => showActionSheet(
                                        context, context.read<SearchProvider>(),
                                        (country) {
                                      provider.postBuilder['location']
                                          ['country'] = country.name;
                                      provider.notifty();
                                    }),
                                context,
                                provider.postBuilder['location']['country']),
                            CupertinoFormRow(
                              padding: const EdgeInsets.all(0),
                              error: provider.postBuilder['location']['city']
                                      .text.isEmpty
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
                              error: provider
                                      .postBuilder['description'].text.isEmpty
                                  ? const Text('Please provide a description')
                                  : null,
                              child: CupertinoTextField(
                                textAlignVertical: TextAlignVertical.top,
                                prefix: Container(
                                  height: 100, // Adjust the height as needed
                                  child: const Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Description :',
                                        style: TextStyle(
                                            color:
                                                CupertinoColors.systemYellow),
                                      ),
                                    ), // Replace this with your actual prefix widget
                                  ),
                                ),
                                placeholder: 'Description',
                                controller: provider.postBuilder['description'],
                                onChanged: (value) => provider.notifty(),
                                minLines: 5,
                                maxLines: 5,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CupertinoFormRow(
                              padding: const EdgeInsets.all(0),
                              error: provider.postBuilder['contact']['phone']
                                      .text.isEmpty
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(
                                          'Please enter your phone number'),
                                    )
                                  : null,
                              child: Row(
                                children: [
                                  CupertinoButton(
                                    child: flagAndCode(
                                        provider.postBuilder['phoneFlag'],
                                        provider.postBuilder['contact']
                                            ['code']),
                                    onPressed: () {
                                      final searchProvider =
                                          context.read<SearchProvider>();

                                      showActionSheet(context, searchProvider,
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
                                      onChanged: (value) => provider.notifty(),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
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
                              error: provider.postBuilder['contact']['type'] ==
                                      null
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
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
                                        onChanged: (checked) => provider
                                            .handleContactType('call', checked),
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
                                        value: provider.postBuilder['whatsapp'],
                                        onChanged: (checked) =>
                                            provider.handleContactType(
                                                'whatsapp', checked))
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton.filled(
                          child: const Text('Update'),
                          onPressed: () {
                            if (!provider.canUpdate()) {
                              showInformativeDialog(
                                  context, 'All informations are required !');
                            } else {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        title: const Text('Confirmation !'),
                                        content: const Text(
                                            'Are you sure you want to proceed with the modifications ?'),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                  color: CupertinoColors.white),
                                            ),
                                            onPressed: () {
                                              context.pop();
                                              provider.submitUpdate(
                                                  onSuccess: () {
                                                showInformativeDialog(
                                                    buildContext,
                                                    'Informations Updated Successfully');
                                              }, onFail: (e) {
                                                logger.e('error updating $e');
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
                    ]),
                  ),
                );
              }),
      )),
    );
  }
}

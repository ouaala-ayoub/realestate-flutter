import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/post_advert_provider.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:svg_flutter/svg.dart';
import '../../models/core/types.dart';

class PropretyInfoStep extends StatelessWidget {
  const PropretyInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostAdvertProvider>(
      builder: (context, provider, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoFormSection(
            header: headerRequired('Property Infos'),
            children: [
              CupertinoFormRow(
                error: provider.data['type'] == null
                    ? const Text('Please choose a type')
                    : null,
                prefix: const Text('Property Type'),
                child: CupertinoButton(
                  onPressed: () =>
                      showPicker(context, provider, availableTypes, 'type',
                          onClicked: (value) {
                    if (value == availableTypes[0]) {
                      provider.data['period'] = null;
                    }
                  }),
                  child: Center(
                      child: Text(provider.data['type'] ?? 'Choose a type')),
                ),
              ),
              CupertinoFormRow(
                  prefix: const Text('Category'),
                  error: provider.data['category'] == null
                      ? const Text('Please choose a category')
                      : null,
                  child: Center(
                    child: CupertinoButton(
                        child: Text(
                            provider.data['category'] ?? 'Choose a category'),
                        onPressed: () {
                          showCategoryActionSheet(
                              context, context.read<SearchProvider>(),
                              (category) {
                            provider.handleDetails(category);
                          });
                        }),
                  )),
              CupertinoFormRow(
                  error: provider.data['price'].text.isEmpty
                      ? const Text('Please enter a price')
                      : null,
                  prefix: const Text('Price (USD \$)'),
                  child: CupertinoTextFormFieldRow(
                    onChanged: (value) => provider.updateNextStatus2(),
                    placeholder: 'Enter a price',
                    controller: provider.data['price'],
                    style: const TextStyle(color: CupertinoColors.systemYellow),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                  )),
              CupertinoFormRow(
                error: provider.data['type'] == 'Rent' &&
                        provider.data['period'] == null
                    ? const Text('Please choose a period')
                    : null,
                prefix: const Text('Period'),
                child: Center(
                  child: CupertinoButton(
                    onPressed: () {
                      if (provider.data['type'] == 'Rent') {
                        showPicker(context, provider, periods, 'period');
                      } else {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  actions: [
                                    CupertinoDialogAction(
                                        onPressed: () => context.pop(),
                                        isDestructiveAction: true,
                                        child: const Text('Cancel'))
                                  ],
                                  content: const Text(
                                    'Property type is not Rent',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ));
                      }
                    },
                    child: Text(provider.data['period'] ?? 'Choose a Period'),
                  ),
                ),
              )
            ],
          ),
          CupertinoFormSection(
              header: headerRequired('Contact Infos'),
              children: [
                CupertinoFormRow(
                    error: provider.data['phoneNumber'].text.isEmpty ||
                            provider.data['phoneCode'] == null
                        ? const Text('Please enter your contact number')
                        : null,
                    prefix: CupertinoButton(
                      child: Row(
                        children: [
                          SvgPicture.network(
                            provider.data['phoneFlag'] ?? '',
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
                          Text(provider.data['phoneCode'] ?? 'phone code'),
                        ],
                      ),
                      onPressed: () {
                        final searchProvider = context.read<SearchProvider>();
                        showActionSheet(context, searchProvider, (country) {
                          provider.setFields(['phoneCode', 'phoneFlag'],
                              [country.dialCode, country.image]);

                          // context.pop();
                        }, showCode: true);
                      },
                    ),
                    child: CupertinoTextFormFieldRow(
                      maxLength: 15,
                      onChanged: (value) => provider.updateNextStatus2(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      placeholder: 'Phone Number',
                      controller: provider.data['phoneNumber'],
                    )),
                CupertinoFormRow(
                    error: !provider.data['contactPhone'] &&
                            !provider.data['contactWhatsapp']
                        ? const Text('Choose atleast one communication method')
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.phone,
                              size: 24,
                            ),
                            CupertinoSwitch(
                              value: provider.data['contactPhone'] ?? false,
                              onChanged: (checked) {
                                provider.setFields(['contactPhone'], [checked]);
                              },
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
                              value: provider.data['contactWhatsapp'] ?? false,
                              onChanged: (checked) {
                                provider
                                    .setFields(['contactWhatsapp'], [checked]);
                              })
                        ]),
                      ],
                    ))
              ])
        ],
      ),
    );
  }

  Column headerRequired(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(color: CupertinoColors.white, fontSize: 17),
          ),
        ),
        // const Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     'required*',
        //     style: TextStyle(color: CupertinoColors.systemRed),
        //   ),
        // )
      ],
    );
  }
}

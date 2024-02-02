import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/post_advert_provider.dart';
import 'package:realestate/providers/search_provider.dart';
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
                    if (value != 'Rent') {
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
          contactInfoSection(provider, context,
              onChangedPhone: () => provider.updateNextStatus2())
        ],
      ),
    );
  }
}

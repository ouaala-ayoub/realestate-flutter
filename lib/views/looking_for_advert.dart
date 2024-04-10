import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/looking_for_provider.dart';
import 'package:realestate/providers/search_provider.dart';

class LookingForAdvertStepOne extends StatelessWidget {
  const LookingForAdvertStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LookingForProvider>(
      builder: (context, provider, _) => CupertinoFormSection(
        // key: provider.formKey,
        header: headerRequired('What Category ?'),
        children: [
          CupertinoFormRow(
            prefix: const Text('Category'),
            error: provider.data['category'] == null
                ? const Text('Please choose a category')
                : null,
            child: Center(
              child: CupertinoButton(
                child: Text(provider.data['category'] ?? 'Choose a category'),
                onPressed: () {
                  showCategoryActionSheet(
                    context,
                    context.read<SearchProvider>(),
                    (category) => provider.setFields(
                      ['category'],
                      [category],
                    ),
                  );
                },
              ),
            ),
          ),
          contactInfoSection(
            provider,
            context,
            onChangedPhone: () => provider.updateNextStatus(),
          )
        ],
      ),
    );
  }
}

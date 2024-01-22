import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/post_advert_provider.dart';
import 'package:realestate/providers/search_provider.dart';

class LocationDataStep extends StatelessWidget {
  const LocationDataStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostAdvertProvider>(
      builder: (context, provider, _) {
        final searchProvider = context.read<SearchProvider>();
        return Column(
          children: [
            CupertinoFormSection(
                header: const Text(
                  'Location',
                  style: TextStyle(color: CupertinoColors.white, fontSize: 17),
                ),
                children: [
                  CupertinoFormRow(
                    prefix: const Text('Choose a country'),
                    error: const Text('required *'),
                    child: Center(
                      child: CupertinoButton(
                          child: Text(provider.data['country'] ?? 'Select'),
                          onPressed: () => showActionSheet(
                                  context, searchProvider, (country) {
                                provider.setCountry(country.name);
                              })),
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Text('City'),
                    error: const Text('required *'),
                    child: CupertinoTextFormFieldRow(
                      onChanged: (value) => provider.updateNextStatus(),
                      placeholder: 'Enter a City',
                      controller: provider.data['city'],
                      maxLength: 20,
                      style:
                          const TextStyle(color: CupertinoColors.systemYellow),
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Text('Area'),
                    child: CupertinoTextFormFieldRow(
                      placeholder: 'Enter a Area',
                      controller: provider.data['area'],
                      maxLength: 20,
                      style:
                          const TextStyle(color: CupertinoColors.systemYellow),
                    ),
                  ),
                ]),
            CupertinoFormSection(
                header: const Text(
                  'Description',
                  style: TextStyle(color: CupertinoColors.white, fontSize: 17),
                ),
                children: [
                  CupertinoFormRow(
                      error: const Text('required *'),
                      child: CupertinoTextFormFieldRow(
                        placeholder: 'Enter a description of the property',
                        controller: provider.data['description'],
                        onChanged: (value) => provider.updateNextStatus(),
                        minLines: 5,
                        maxLines: 5,
                        maxLength: 250,
                      ))
                ])
          ],
        );
      },
    );
  }
}
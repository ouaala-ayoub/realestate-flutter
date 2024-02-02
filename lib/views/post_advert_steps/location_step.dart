import 'package:flutter/cupertino.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/loader_provider.dart';

class LocationStepBody extends StatelessWidget {
  final LoaderProvider loaderProvider;
  const LocationStepBody({
    super.key,
    required this.searchProvider,
    required this.loaderProvider,
  });

  final SearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {
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
                error: loaderProvider.data['country'] == null
                    ? const Text('Please enter a country')
                    : null,
                child: Center(
                  child: CupertinoButton(
                      child: Text(loaderProvider.data['country'] ?? 'Select'),
                      onPressed: () =>
                          showActionSheet(context, searchProvider, (country) {
                            loaderProvider.setCountry(country.name);
                          })),
                ),
              ),
              CupertinoFormRow(
                prefix: const Text('City'),
                error: loaderProvider.data['city'].text.isEmpty
                    ? const Text('Please enter a city')
                    : null,
                child: CupertinoTextFormFieldRow(
                  onChanged: (value) => loaderProvider.updateNextStatus(),
                  placeholder: 'Enter a City',
                  controller: loaderProvider.data['city'],
                  maxLength: 20,
                  style: const TextStyle(color: CupertinoColors.systemYellow),
                ),
              ),
              CupertinoFormRow(
                prefix: const Text('Area'),
                child: CupertinoTextFormFieldRow(
                  placeholder: 'Enter a Area',
                  controller: loaderProvider.data['area'],
                  maxLength: 20,
                  style: const TextStyle(color: CupertinoColors.systemYellow),
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
                  error: loaderProvider.data['description'].text.isEmpty
                      ? const Text('Please enter a description')
                      : null,
                  child: CupertinoTextFormFieldRow(
                    placeholder: 'Description',
                    controller: loaderProvider.data['description'],
                    onChanged: (value) => loaderProvider.updateNextStatus(),
                    minLines: 5,
                    maxLines: 5,
                    maxLength: 250,
                  ))
            ])
      ],
    );
  }
}

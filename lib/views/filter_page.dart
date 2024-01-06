import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/core/price_filter.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import '../models/core/types.dart';
import '../providers/search_provider.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('filter page')),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) => Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SafeArea(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: CupertinoSegmentedControl<String>(
                            groupValue:
                                searchProvider.searchParams.type ?? 'All',
                            children: {
                              for (var element in types)
                                element: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    element,
                                    style: const TextStyle(
                                        color: CupertinoColors.white),
                                  ),
                                )
                            },
                            onValueChanged: (String? value) {
                              searchProvider.setSelectedType(value);
                            },
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const TitleWidget(text: 'Location'),
                      chooseButton(
                          'country',
                          () => showActionSheet(
                              context, searchProvider, (country) {}),
                          context,
                          searchProvider),
                      chooseButton(
                          'category',
                          () => showCategoryActionSheet(
                              context, searchProvider, (category) {}),
                          context,
                          searchProvider),
                      const TitleWidget(
                        text: 'Price Filter',
                      ),
                      Column(
                        children: [
                          CupertinoListTile(
                            title: GestureDetector(
                                onTap: () {
                                  searchProvider
                                      .setPriceFilter(PriceFilter.high);
                                },
                                child: const Text('High')),
                            leading: CupertinoRadio<PriceFilter>(
                              groupValue:
                                  searchProvider.searchParams.priceFilter,
                              value: PriceFilter.high,
                              activeColor: CupertinoColors.systemYellow,
                              onChanged: (value) {
                                searchProvider.setPriceFilter(value);
                              },
                            ),
                          ),
                          CupertinoListTile(
                            title: GestureDetector(
                                onTap: () {
                                  searchProvider
                                      .setPriceFilter(PriceFilter.low);
                                },
                                child: const Text('Low')),
                            leading: CupertinoRadio<PriceFilter>(
                              groupValue:
                                  searchProvider.searchParams.priceFilter,
                              value: PriceFilter.low,
                              activeColor: CupertinoColors.systemYellow,
                              onChanged: (value) {
                                searchProvider.setPriceFilter(value);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton.filled(
                  child: const Text('testing'),
                  onPressed: () {
                    context.pop(true);
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String text;
  const TitleWidget({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
              color: CupertinoColors.systemYellow,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
    );
  }
}

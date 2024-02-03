import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/core/price_filter.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import '../models/core/types.dart';
import '../providers/search_provider.dart';
import 'feature_widget.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  void initState() {
    super.initState();
    context.read<SearchProvider>().initiateQueries();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('filter page')),
      child: SafeArea(
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) => Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: CupertinoSegmentedControl<String>(
                                padding: EdgeInsets.zero,
                                groupValue:
                                    searchProvider.tempQueries['type'] ?? 'All',
                                children: {
                                  for (var element in types)
                                    element: Text(
                                      overflow: TextOverflow.ellipsis,
                                      element,
                                      style: TextStyle(
                                          color: searchProvider.tempQueries[
                                                          'type'] ==
                                                      element ||
                                                  (element == 'All' &&
                                                      searchProvider
                                                                  .tempQueries[
                                                              'type'] ==
                                                          null)
                                              ? CupertinoColors.black
                                              : CupertinoColors.white),
                                    )
                                },
                                onValueChanged: (String? value) {
                                  searchProvider.setTempField('type', value);
                                },
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          const TitleWidget(text: 'Location'),
                          chooseButton(
                              'country',
                              () => showActionSheet(context, searchProvider,
                                      (country) {
                                    searchProvider.setTempField(
                                        'country', country.name);
                                  }),
                              context,
                              searchProvider.tempQueries['country'],
                              onClearClicked: () =>
                                  searchProvider.setTempField('country', null)),
                          CupertinoTextField(
                            placeholder: 'Enter a city',
                            controller: searchProvider.tempQueries['city'],
                            prefix: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: smallTitle('City :'),
                            ),
                          ),
                          // CupertinoTextField(
                          //   onChanged: (value) =>
                          //       searchProvider.setTempField('city', value),
                          //   prefix: Padding(
                          //     padding: const EdgeInsets.only(left: 5),
                          //     child: smallTitle('Area :'),
                          //   ),
                          // ),
                          chooseButton(
                            'category',
                            () => showCategoryActionSheet(
                              context,
                              searchProvider,
                              (category) {
                                final needDetail =
                                    detailedCategories.contains(category);
                                searchProvider.setTempField(
                                    'category', category);

                                searchProvider.setTempField(
                                    'features', needDetail ? [] : null);
                                if (!needDetail) {
                                  searchProvider.setTempField(
                                      'condition', null);
                                }
                              },
                            ),
                            context,
                            searchProvider.tempQueries['category'],
                            onClearClicked: () =>
                                searchProvider.setTempField('category', null),
                          ),
                          const TitleWidget(
                            text: 'Price Filter',
                          ),
                          Column(
                            children: [
                              CupertinoListTile(
                                title: GestureDetector(
                                    onTap: () {
                                      searchProvider.setTempField(
                                          'priceFilter', PriceFilter.high);
                                    },
                                    child: const Text('High')),
                                leading: CupertinoRadio<PriceFilter>(
                                  groupValue:
                                      searchProvider.tempQueries['priceFilter'],
                                  value: PriceFilter.high,
                                  activeColor: CupertinoColors.systemYellow,
                                  onChanged: (value) {
                                    searchProvider.setTempField(
                                        'priceFilter', value);
                                  },
                                ),
                              ),
                              CupertinoListTile(
                                title: GestureDetector(
                                    onTap: () {
                                      searchProvider.setTempField(
                                          'priceFilter', PriceFilter.low);
                                    },
                                    child: const Text('Low')),
                                leading: CupertinoRadio<PriceFilter>(
                                  groupValue:
                                      searchProvider.tempQueries['priceFilter'],
                                  value: PriceFilter.low,
                                  activeColor: CupertinoColors.systemYellow,
                                  onChanged: (value) {
                                    searchProvider.setTempField(
                                        'priceFilter', value);
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      detailedCategories
                              .contains(searchProvider.tempQueries['category'])
                          ? moreDetails(searchProvider, context)
                          : const SizedBox(
                              height: 0,
                            )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton.filled(
                    child: const Text('Filter'),
                    onPressed: () {
                      //todo add filter logic
                      searchProvider.setFilters();
                      logger.i(searchProvider.searchParams.toMap());
                      context.pop(true);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column moreDetails(SearchProvider searchProvider, BuildContext context) {
    return Column(
      children: [
        const TitleWidget(text: 'More Details'),
        Center(
          child: CupertinoButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Property Condition :',
                  style: TextStyle(color: CupertinoColors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(searchProvider.tempQueries['condition'] ?? 'Choose'),
              ],
            ),
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                        cancelButton: cancelButton(context),
                        actions: conditions
                            .map((condition) => CupertinoActionSheetAction(
                                onPressed: () {
                                  searchProvider.setTempField(
                                      'condition', condition);
                                  context.pop();
                                },
                                child: Text(
                                  condition,
                                  style: const TextStyle(
                                      color: CupertinoColors.white),
                                )))
                            .toList(),
                      ));
            },
          ),
        ),
        CupertinoButton(
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LandMarks/Facilities : ',
                style: TextStyle(color: CupertinoColors.white),
              ),
              Text('Choose')
            ],
          ),
          onPressed: () {
            showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                      title: const Text(
                        'Please Check the features you are looking for!',
                        style: TextStyle(
                            fontSize: 18, color: CupertinoColors.white),
                      ),
                      cancelButton: CupertinoButton(
                          child: const Text(
                            'Done',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                          onPressed: () => context.pop(())),
                      actions: landMarks.entries
                          .map((entry) => FeatureWidget(
                              isChecked: searchProvider.tempQueries['features']
                                      ?.contains(entry.key) ==
                                  true,
                              svgPath: entry.value,
                              featureText: entry.key,
                              onChecked: (checked) =>
                                  searchProvider.handleFeature(entry.key)))
                          .toList(),
                    ));
          },
        )
      ],
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
            color: CupertinoColors.systemYellow,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }
}

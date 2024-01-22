import 'dart:io';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/core/country.dart';
import 'package:realestate/providers/filterabli_choices_list.dart';
import 'package:realestate/views/country_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../providers/post_advert_provider.dart';
import '../../providers/search_provider.dart';
import 'dart:typed_data';

double squareMetersToSquareFeet(double? squareMeters) {
  if (squareMeters == null) return 0.0;
  return double.parse((squareMeters * 10.764).toStringAsFixed(2));
}

String formatPrice(int? price) {
  // Using the Flutter's NumberFormat class for currency formatting
  final formatter = NumberFormat.currency(
    symbol: '\$', // You can customize the currency symbol
    decimalDigits: 2, // Specify the number of decimal places
  );

  // Format the price and return as a string
  return formatter.format(price);
}

void showCategoryActionSheet<T>(BuildContext context,
    SearchProvider searchProvider, Function(String) onSelected) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => searchProvider.categoriesLoading
        ? const CupertinoActivityIndicator()
        : searchProvider.categories.fold(
            (l) => Center(
                  child: CupertinoButton(
                    child: const Text('Unexpected error'),
                    onPressed: () => searchProvider.getCategories(),
                  ),
                ),
            (categories) => ChangeNotifierProvider(
                  create: (context) => ItemChoiceProvider(categories),
                  builder: (context, _) => Center(
                    child: CupertinoActionSheet(
                      cancelButton: cancelButton(context),
                      actions: context
                          .watch<ItemChoiceProvider<dynamic>>()
                          .filtred
                          .map((category) => GestureDetector(
                                onTap: () {
                                  logger.i(category);
                                  // searchProvider.setSelectedCategory(category);
                                  onSelected(category);
                                  context.pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(category),
                                ),
                              ))
                          .toList(),
                      title: Column(
                        children: [
                          const Text(
                            'Pick a Category',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CupertinoSearchTextField(
                            onChanged: (query) {
                              context
                                  .read<ItemChoiceProvider>()
                                  .runFilter(query);
                            },
                            onSubmitted: (query) {
                              context
                                  .read<ItemChoiceProvider>()
                                  .runFilter(query);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
  );
}

CupertinoButton cancelButton(BuildContext context) {
  return CupertinoButton(
      child: const Text(
        'Cancel',
        style: TextStyle(color: CupertinoColors.systemRed),
      ),
      onPressed: () => context.pop());
}

void showActionSheet(BuildContext context, SearchProvider searchProvider,
    Function(Country country) onSelected) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => searchProvider.countriesLoading
        ? const CupertinoActivityIndicator()
        : searchProvider.countries.fold(
            (l) => Center(
                  child: CupertinoButton(
                    child: const Text('Unexpected error Refresh'),
                    onPressed: () => searchProvider.getCountries(),
                  ),
                ),
            (countries) => ChangeNotifierProvider(
                  create: (context) => ItemChoiceProvider<Country>(countries),
                  builder: (context, widget) => Center(
                    child: CupertinoActionSheet(
                      cancelButton: cancelButton(context),
                      actions: context
                          .watch<ItemChoiceProvider<Country>>()
                          .filtred
                          .map((country) => GestureDetector(
                                onTap: () {
                                  logger.i(country);
                                  // searchProvider.setSelectedCountry(country);
                                  onSelected(country);
                                  context.pop();
                                },
                                child: CountryInfo(
                                  country: country,
                                  showCode: false,
                                ),
                              ))
                          .toList(),
                      title: Column(
                        children: [
                          const Text(
                            'Pick a country',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          //todo add search functionality
                          CupertinoSearchTextField(
                            onChanged: (query) {
                              context
                                  .read<ItemChoiceProvider<Country>>()
                                  .runFilter(query);
                            },
                            onSubmitted: (query) {
                              context
                                  .read<ItemChoiceProvider<Country>>()
                                  .runFilter(query);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
  );
}

showPicker(BuildContext context, PostAdvertProvider? provider,
    List<String> values, String key,
    {Function(String)? onClicked}) {
  showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
            actions: values
                .map((value) => GestureDetector(
                      onTap: () {
                        onClicked?.call(value);
                        provider?.setFields([key], [value]);
                        context.pop();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(value)),
                    ))
                .toList(),
          ));
}

showEditPicker(BuildContext context, values, {Function(String)? onClicked}) {
  showPicker(context, null, values, '', onClicked: onClicked);
}

CupertinoButton chooseButton(
    String target, Function onPressed, BuildContext context, String? toShow) {
  return CupertinoButton(
    onPressed: () => onPressed(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Choose a $target',
          style: const TextStyle(color: CupertinoColors.white),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Center(
            child: Text(
              toShow ?? 'Select',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Icon(
          CupertinoIcons.forward,
          size: 16.0, // Adjust the size as needed
        ),
      ],
    ),
  );
}

whatsapp(contact, Function() onFail) async {
  var androidUrl =
      "whatsapp://send?phone=$contact&text=Hi, is this article available ?";
  var iosUrl =
      "https://wa.me/$contact?text=${Uri.parse('Hi, is this article available ?')}";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    onFail();
  }
}

String createUniqueImageName({required String extension}) {
  final random = Random.secure();
  final now = DateTime.now().millisecondsSinceEpoch;
  final bytes =
      Uint8List.fromList(List.generate(6, (_) => random.nextInt(256)));
  final hex =
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  return '$now.$hex.$extension';
}

String getFileExtension(XFile xFile) {
  String path = xFile.path;
  int dotIndex = path.lastIndexOf('.');
  if (dotIndex != -1 && dotIndex < path.length - 1) {
    String extension = path.substring(dotIndex + 1);
    return extension;
  }
  return 'unknown';
}

launchWebSite(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}

// _launchInstagram() async {
//   const nativeUrl = "instagram://user?username=severinas_app";
//   const webUrl = "https://www.instagram.com/severinas_app/";
//   if (await canLaunch(nativeUrl)) {
//     await launch(nativeUrl);
//   } else if (await canLaunch(webUrl)) {
//     await launch(webUrl);
//   } else {
//     print("can't open Instagram");
//   }
// }

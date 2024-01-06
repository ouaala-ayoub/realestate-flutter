import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/country.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../providers/search_provider.dart';

double squareMetersToSquareFeet(double squareMeters) =>
    double.parse((squareMeters * 10.764).toStringAsFixed(4));

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
            (l) => const Center(
                  child: Text('Unexpected error'),
                ),
            (categories) => CupertinoActionSheet(
                  actions: categories
                      .map((category) => GestureDetector(
                            onTap: () {
                              logger.i(category);
                              searchProvider.setSelectedCategory(category);
                              onSelected(category);
                              context.pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(category),
                            ),
                          ))
                      .toList(),
                  title: const Column(
                    children: [
                      Text(
                        'Pick a Category',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //todo add search functionality
                      CupertinoSearchTextField(),
                    ],
                  ),
                )),
  );
}

void showActionSheet(BuildContext context, SearchProvider searchProvider,
    Function(Country country) onSelected) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => searchProvider.countriesLoading
        ? const CupertinoActivityIndicator()
        : searchProvider.countries.fold(
            (l) => const Center(
                  child: Text('Unexpected error'),
                ),
            (countries) => CupertinoActionSheet(
                  actions: countries
                      .map((country) => GestureDetector(
                            onTap: () {
                              logger.i(country);
                              searchProvider.setSelectedCountry(country);
                              onSelected(country);
                              context.pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(country.name),
                            ),
                          ))
                      .toList(),
                  title: const Column(
                    children: [
                      Text(
                        'Pick a country',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //todo add search functionality
                      CupertinoSearchTextField(),
                    ],
                  ),
                )),
  );
}

CupertinoButton chooseButton(String target, Function onPressed,
    BuildContext context, SearchProvider searchProvider) {
  final toShow = target == 'country'
      ? searchProvider.searchParams.country
      : searchProvider.searchParams.category;
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

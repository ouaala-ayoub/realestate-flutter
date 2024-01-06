import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/country.dart';
import 'package:realestate/models/core/search_params.dart';
import '../models/core/price_filter.dart';
import '../models/helpers/static_data_helper.dart';

class SearchProvider extends ChangeNotifier {
  final helper = StaticDataHelper();
  Either<dynamic, List<Country>> countries = const Right([]);
  Either<dynamic, List<dynamic>> categories = const Right([]);
  bool countriesLoading = false;
  bool categoriesLoading = false;

  SearchParams searchParams = SearchParams.initial();

  setSelectedCountry(Country? value) {
    searchParams.country = value?.name;
    notifyListeners();
  }

  setSelectedType(String? value) {
    searchParams.type = value == 'All' ? null : value;
    notifyListeners();
  }

  setPriceFilter(PriceFilter? value) {
    searchParams.priceFilter = value;
    notifyListeners();
  }

  setSelectedCategory(String? value) {
    searchParams.category = value;
    notifyListeners();
  }

  getCountries() async {
    countriesLoading = true;
    countries = await helper.getCountries();
    countriesLoading = false;
    notifyListeners();
  }

  getCategories() async {
    categoriesLoading = true;
    categories = await helper.getCategories();
    categoriesLoading = false;
    notifyListeners();
  }
}

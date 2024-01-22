import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/country.dart';
import 'package:realestate/models/core/search_params.dart';
import '../models/helpers/static_data_helper.dart';

class SearchProvider extends ChangeNotifier {
  final helper = StaticDataHelper();
  Either<dynamic, List<Country>> countries = const Right([]);
  Either<dynamic, List<dynamic>> categories = const Right([]);
  bool countriesLoading = false;
  bool categoriesLoading = false;
  Map<String, dynamic> tempQueries = {
    'type': null,
    'country': null,
    'category': null,
    'priceFilter': null,
    'condition': null,
    'features': null
  };

  SearchParams searchParams = SearchParams.initial();

  setTempField(String key, value) {
    tempQueries[key] = value;
    notifyListeners();
  }

  setSelectedCountry(Country? value) {
    // tempQueries['country'] = value;
    searchParams.country = value?.name;
    notifyListeners();
  }

  setSelectedType(String? value) {
    // tempQueries['type'] = value == 'All' ? null : value;
    searchParams.type = value == 'All' ? null : value;
    notifyListeners();
  }

  setSelectedCategory(String? value) {
    // tempQueries['category'] = value;
    searchParams.category = value;
    notifyListeners();
  }

  handleFeature(String feature) {
    tempQueries['features']?.contains(feature) == true
        ? tempQueries['features']?.remove(feature)
        : tempQueries['features']?.add(feature);
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

  void initiateQueries() {
    tempQueries = {
      'type': searchParams.type,
      'country': searchParams.country,
      'category': searchParams.category,
      'priceFilter': searchParams.priceFilter,
      'condition': searchParams.condition,
      'features': searchParams.features
    };
  }

  void setFilters() {
    searchParams.type = tempQueries['type'];
    searchParams.country = tempQueries['country'];
    searchParams.category = tempQueries['category'];
    searchParams.priceFilter = tempQueries['priceFilter'];
    searchParams.condition = tempQueries['condition'];
    searchParams.features = tempQueries['features'];
  }

  void refreshParams() {
    searchParams = SearchParams.initial();
    notifyListeners();
  }

  void setSearchQuery(String? query) {
    searchParams.search = query;
    notifyListeners();
  }
}

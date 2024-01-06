import 'package:realestate/models/core/price_filter.dart';

class SearchParams {
  String? search;
  String? country;
  String? city;
  String? category;
  String? type;
  PriceFilter? priceFilter;
  String? n;
  String? condition;
  int page = 1;
  List<String>? features;
  SearchParams(
      {this.search,
      this.country,
      this.city,
      this.category,
      this.type,
      this.priceFilter,
      this.n,
      this.condition,
      this.page = 1,
      this.features});

  Map<String, dynamic> toMap() => {
        'search': search,
        'country': country,
        'city': city,
        'category': category,
        'type': type,
        'n': n,
        'condition': condition,
        'page': page.toString(),
        'features': features,
      }..removeWhere((key, value) => value == null);

  SearchParams.initial();
}

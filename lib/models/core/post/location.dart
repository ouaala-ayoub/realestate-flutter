import 'dart:convert';

class Location {
  final String? country;
  final String? city;
  final String? area;

  const Location({this.country, this.city, this.area});

  @override
  String toString() {
    return 'Location(country: $country, city: $city, area: $area)';
  }

  factory Location.fromMap(Map<String, dynamic> data) => Location(
        country: data['country'] as String?,
        city: data['city'] as String?,
        area: data['area'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'country': country,
        'city': city,
        'area': area,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Location].
  factory Location.fromJson(String data) {
    return Location.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Location] to a JSON string.
  String toJson() => json.encode(toMap());
}

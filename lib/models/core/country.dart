import 'dart:convert';

class Country {
  String name;
  String dialCode;
  String code;
  String image;

  Country(
      {required this.name,
      required this.dialCode,
      required this.code,
      required this.image});

  @override
  String toString() {
    return 'Country(name: $name, dialCode: $dialCode, code: $code, image: $image)';
  }

  factory Country.fromMap(Map<String, dynamic> data) => Country(
        name: data['name'].toString(),
        dialCode: data['dial_code'].toString(),
        code: data['code'].toString(),
        image: data['image'].toString(),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'dial_code': dialCode,
        'code': code,
        'image': image,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Country].
  factory Country.fromJson(String data) {
    return Country.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Country] to a JSON string.
  String toJson() => json.encode(toMap());
}

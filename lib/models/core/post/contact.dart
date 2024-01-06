import 'dart:convert';

class Contact {
  final String? code;
  final String? phone;
  final String? type;

  const Contact({this.code, this.phone, this.type});

  @override
  String toString() => 'Contact(code: $code, phone: $phone, type: $type)';

  factory Contact.fromMap(Map<String, dynamic> data) => Contact(
        code: data['code'] as String?,
        phone: data['phone'] as String?,
        type: data['type'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'code': code,
        'phone': phone,
        'type': type,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Contact].
  factory Contact.fromJson(String data) {
    return Contact.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Contact] to a JSON string.
  String toJson() => json.encode(toMap());
}

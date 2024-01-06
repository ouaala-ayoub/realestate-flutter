import 'dart:convert';

class RealestateUser {
  final String? id;
  final String? email;
  final String? name;
  final List<dynamic>? socials;
  final String? image;
  final List<dynamic>? likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? status;

  const RealestateUser({
    this.id,
    this.email,
    this.name,
    this.socials,
    this.image,
    this.likes,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.status,
  });

  @override
  String toString() {
    return 'Owner(id: $id, email: $email, name: $name, socials: $socials, image: $image, likes: $likes, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, status: $status)';
  }

  factory RealestateUser.fromMap(Map<String, dynamic> data) => RealestateUser(
        id: data['_id'] as String?,
        email: data['email'] as String?,
        name: data['name'] as String?,
        socials: data['socials'] as List<dynamic>?,
        image: data['image'] as String?,
        likes: data['likes'] as List<dynamic>?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        v: data['__v'] as int?,
        status: data['status'] as String?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'email': email,
        'socials': socials,
        'image': image,
        'likes': likes,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RealestateUser].
  factory RealestateUser.fromJson(String data) {
    return RealestateUser.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RealestateUser] to a JSON string.
  String toJson() => json.encode(toMap());
}

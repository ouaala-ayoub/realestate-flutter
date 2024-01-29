import 'dart:convert';
import 'contact.dart';
import 'location.dart';
import 'owner.dart';

class Post {
  final String? id;
  final String? description;
  final List<dynamic>? media;
  final String? category;
  final int? price;
  final Location? location;
  String? status;
  final List<dynamic>? rejectReasons;
  final dynamic owner;
  final String? type;
  final String? period;
  int? likes;
  final List<dynamic>? features;
  final String? condition;
  final int? rooms;
  final int? bathrooms;
  final int? floors;
  final int? floorNumber;
  final num? space;
  final Contact? contact;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Post({
    this.id,
    this.description,
    this.media,
    this.category,
    this.price,
    this.location,
    this.status,
    this.rejectReasons,
    this.owner,
    this.type,
    this.period,
    this.likes = 0,
    this.features,
    this.condition,
    this.rooms,
    this.bathrooms,
    this.floors,
    this.floorNumber,
    this.space,
    this.contact,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Post(id: $id, description: $description, media: $media, category: $category, price: $price, location: $location, status: $status, rejectReasons: $rejectReasons, owner: $owner, type: $type, period: $period, likes: $likes, features: $features, contact: $contact, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Post.fromMap(Map<String, dynamic> data, {required bool withOwner}) =>
      Post(
        id: data['_id'] as String?,
        description: data['description'] as String?,
        media: data['media'] as List<dynamic>?,
        category: data['category'] as String?,
        price: data['price'] as int?,
        location: data['location'] == null
            ? null
            : Location.fromMap(data['location'] as Map<String, dynamic>),
        status: data['status'] as String?,
        rejectReasons: data['rejectReasons'] as List<dynamic>?,
        owner: data['owner'] == null
            ? null
            : withOwner
                ? RealestateUser.fromMap(data['owner'] as Map<String, dynamic>)
                : data['owner'] as String,
        type: data['type'] as String?,
        period: data['period'] as String?,
        likes: data['likes'] as int?,
        features: data['features'] as List<dynamic>?,
        condition: data['condition'] as String?,
        rooms: data['rooms'] as int?,
        bathrooms: data['bathrooms'] as int?,
        floors: data['floors'] as int?,
        floorNumber: data['floorNumber'] as int?,
        space: data['space'] as num?,
        contact: data['contact'] == null
            ? null
            : Contact.fromMap(data['contact'] as Map<String, dynamic>),
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        v: data['__v'] as int?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'description': description,
        'media': media,
        'category': category,
        'price': price,
        'location': location?.toMap(),
        'status': status,
        'rejectReasons': rejectReasons,
        'owner': owner?.toMap(),
        'type': type,
        'period': period,
        'likes': likes,
        'features': features,
        'condition': condition,
        'rooms': rooms,
        'bathrooms': bathrooms,
        'floors': floors,
        'floorNumber': floorNumber,
        'space': space,
        'contact': contact?.toMap(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Post].
  factory Post.fromJson(String data, {required bool withOwner}) {
    return Post.fromMap(json.decode(data) as Map<String, dynamic>,
        withOwner: withOwner);
  }

  /// `dart:convert`
  ///
  /// Converts [Post] to a JSON string.
  String toJson() => json.encode(toMap());
}

import 'dart:convert';

class Report {
  String? id;
  String? status;
  String? post;
  String? user;
  List<String>? reasons;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Report({
    this.id,
    this.status,
    this.post,
    this.user,
    this.reasons,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Report(id: $id, status: $status, post: $post, user: $user, reasons: $reasons, message: $message, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Report.fromMap(Map<String, dynamic> data) => Report(
        id: data['_id'] as String?,
        status: data['status'] as String?,
        post: data['post'] as String?,
        user: data['user'] as String?,
        reasons: data['reasons'] as List<String>?,
        message: data['message'] as String?,
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
        'status': status,
        'post': post,
        'user': user,
        'reasons': reasons,
        'message': message,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Report].
  factory Report.fromJson(String data) {
    return Report.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Report] to a JSON string.
  String toJson() => json.encode(toMap());
}

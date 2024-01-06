import 'dart:convert';

class LatesNews {
  String? image;
  String? title;
  List<dynamic>? contents;

  LatesNews({this.image, this.title, this.contents});

  @override
  String toString() {
    return 'LatesNews(image: $image, title: $title, contents: $contents)';
  }

  factory LatesNews.fromMap(Map<String, dynamic> data) => LatesNews(
        image: data['image'] as String?,
        title: data['title'] as String?,
        contents: data['contents'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'image': image,
        'title': title,
        'contents': contents,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LatesNews].
  factory LatesNews.fromJson(String data) {
    return LatesNews.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LatesNews] to a JSON string.
  String toJson() => json.encode(toMap());
}

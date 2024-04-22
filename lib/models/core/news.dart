import 'dart:convert';

class News {
	String? id;
	String? title;
	String? content;
	String? image;
	String? link;
	int? v;

	News({this.id, this.title, this.content, this.image, this.link, this.v});

	@override
	String toString() {
		return 'News(id: $id, title: $title, content: $content, image: $image, link: $link, v: $v)';
	}

	factory News.fromMap(Map<String, dynamic> data) => News(
				id: data['_id'] as String?,
				title: data['title'] as String?,
				content: data['content'] as String?,
				image: data['image'] as String?,
				link: data['link'] as String?,
				v: data['__v'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'_id': id,
				'title': title,
				'content': content,
				'image': image,
				'link': link,
				'__v': v,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [News].
	factory News.fromJson(String data) {
		return News.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [News] to a JSON string.
	String toJson() => json.encode(toMap());
}

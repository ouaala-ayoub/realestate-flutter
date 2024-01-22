import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/lates_news.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/models/services/static_data_api.dart';
import '../core/country.dart';

// ! important because there is a object in dart also called io
import 'dart:io' as io;

class StaticDataHelper {
  static final _api = StaticDataApi();
  Future<Either<dynamic, List<Country>>> getCountries() async {
    final res = await _api.getCountries();
    return res.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r.map((e) => Country.fromMap(e)).toList());
    });
  }

  Future<Either<dynamic, LatesNews>> getNews() async {
    final res = await _api.getNews();
    return res.fold((l) {
      return Left(l);
    }, (r) {
      return Right(LatesNews.fromMap(r));
    });
  }

  Future<Either<dynamic, List<dynamic>>> getCategories() async {
    final res = await _api.getCategories();
    return res;
  }

  Future<Either<dynamic, List<String>>> uploadImages(dynamic images) async {
    // images.map((image) => logger.i(createUniqueImageName(extension: )));
    final urls = <String>[];
    final firebaseRef = FirebaseStorage.instance.ref();
    for (var image in images) {
      try {
        final ext = getFileExtension(image);
        final fileName = createUniqueImageName(extension: ext);
        final metadata = SettableMetadata(
          contentType: 'image/$ext',
        );
        final uploadTask = await firebaseRef
            .child('posts/$fileName')
            .putFile(io.File(image.path), metadata);
        final url = await uploadTask.ref.getDownloadURL();
        urls.add(url);
      } catch (e) {
        logger.e(e);
        return Left(e);
      }
    }
    return Right(urls);
  }
}

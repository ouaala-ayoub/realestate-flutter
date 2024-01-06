import 'package:dartz/dartz.dart';
import 'package:realestate/models/core/lates_news.dart';
import 'package:realestate/models/services/static_data_api.dart';
import '../core/country.dart';

class StaticDataHelper {
  final api = StaticDataApi();
  Future<Either<dynamic, List<Country>>> getCountries() async {
    final res = await api.getCountries();
    return res.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r.map((e) => Country.fromMap(e)).toList());
    });
  }

  Future<Either<dynamic, LatesNews>> getNews() async {
    final res = await api.getNews();
    return res.fold((l) {
      return Left(l);
    }, (r) {
      return Right(LatesNews.fromMap(r));
    });
  }

  Future<Either<dynamic, List<dynamic>>> getCategories() async {
    final res = await api.getCategories();
    return res;
  }
}

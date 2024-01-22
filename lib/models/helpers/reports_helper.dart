import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:realestate/models/core/report.dart';
import 'package:realestate/models/services/reports_api.dart';

class ReportsHelper {
  Future<Either<dynamic, String>> sendReport(Report report) async {
    try {
      final res = await ReportsApi().sendReport(report);
      return Right(res['message']);
    } on DioException catch (dioException) {
      return Left(dioException);
    } catch (e) {
      return Left(e);
    }
  }
}

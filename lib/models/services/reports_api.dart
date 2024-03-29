import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/core/report.dart';
import 'package:realestate/models/services/posts_api.dart';

class ReportsApi {
  Future<dynamic> sendReport(Report report) async {
    final endpoint = '$baseWebsiteUrl/reports';
    final options = await retrieveCookieOptions();
    final res =
        await Dio(options).post(endpoint, data: jsonEncode(report.toMap()));
    return res.data;
  }
}

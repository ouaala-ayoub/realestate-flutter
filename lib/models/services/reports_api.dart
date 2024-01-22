import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:realestate/models/core/report.dart';
import 'package:realestate/models/services/posts_api.dart';

class ReportsApi {
  Future<dynamic> sendReport(Report report) async {
    const endpoint = 'https://realestatefy.vercel.app/api/reports';
    final options = await retrieveCookieOptions();
    final res =
        await Dio(options).post(endpoint, data: jsonEncode(report.toMap()));
    return res.data;
  }
}

import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../domain/summary_models.dart';

class SummaryApi {
  final Dio _dio;

  SummaryApi({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  Future<SummaryData> fetchSummary({String? date}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/mobile/summary',
      queryParameters: date == null ? null : {'date': date},
    );

    final data = response.data ?? {};
    return SummaryData.fromJson(data);
  }
}

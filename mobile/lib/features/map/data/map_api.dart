import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../domain/map_models.dart';

class MapApi {
  final Dio _dio;

  MapApi({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  Future<List<PointItem>> fetchPoints({
    required int sectorId,
    required int subactivityId,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/mobile/points',
      queryParameters: {
        'sector_id': sectorId,
        'subactivity_id': subactivityId,
      },
    );

    final data = response.data ?? [];
    return data
        .map((item) => PointItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

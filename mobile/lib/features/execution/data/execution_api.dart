import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../domain/execution_models.dart';

class ExecutionApi {
  final Dio _dio;

  ExecutionApi({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  Future<ExecutionResponseModel> createExecution(ExecutionRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/mobile/executions',
      data: request.toJson(),
    );

    final data = response.data ?? {};
    return ExecutionResponseModel.fromJson(data);
  }

  Future<void> uploadEvidence({
    required int executionId,
    required String deviceId,
    required String filePath,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    await _dio.post<void>(
      '/mobile/evidence',
      queryParameters: {'execution_id': executionId},
      data: formData,
      options: Options(headers: {'X-Device-Id': deviceId}),
    );
  }
}

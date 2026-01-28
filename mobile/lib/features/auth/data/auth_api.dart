import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class AuthApi {
  final Dio _dio;

  AuthApi({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  Future<String> login({required String email, required String password}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data;
    if (data == null || data['access_token'] == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid response',
      );
    }

    return data['access_token'] as String;
  }
}

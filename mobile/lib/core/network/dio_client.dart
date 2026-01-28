import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

class DioClient {
  DioClient._internal();

  static final DioClient instance = DioClient._internal();

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.add(AuthInterceptor(TokenStorage.instance));
}

import 'dart:io';

import 'package:api/api.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends QueuedInterceptor {
  TokenInterceptor({required TokenProvider tokenProvider})
      : _tokenProvider = tokenProvider;

  final TokenProvider _tokenProvider;

  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider();
    options.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    handler.next(options);
  }
}

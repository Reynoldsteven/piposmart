import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'token_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}

class PagedResult<T> {
  final List<T> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PagedResult({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

class ApiClient {
  ApiClient({TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  late final Dio _dio;
  final TokenStorage _tokenStorage;

  Dio get dio => _dio;

  Future<T> post<T>(String path, {Object? data, T Function(dynamic raw)? parser}) async {
    try {
      final response = await _dio.post(path, data: data);
      return _unwrap(response.data, parser: parser);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<T> put<T>(String path, {Object? data, T Function(dynamic raw)? parser}) async {
    try {
      final response = await _dio.put(path, data: data);
      return _unwrap(response.data, parser: parser);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic raw)? parser,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _unwrap(response.data, parser: parser);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<PagedResult<T>> getPaged<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> json) itemParser,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      final body = response.data;
      if (body is! Map<String, dynamic> || body['success'] != true) {
        throw ApiException(body is Map ? (body['error']?.toString() ?? 'Terjadi kesalahan') : 'Respons API tidak valid');
      }
      final rawList = body['data'];
      final items = <T>[];
      if (rawList is List) {
        for (final e in rawList) {
          if (e is Map<String, dynamic>) {
            items.add(itemParser(e));
          } else if (e is Map) {
            items.add(itemParser(Map<String, dynamic>.from(e)));
          }
        }
      }
      final meta = body['meta'] is Map<String, dynamic>
          ? body['meta'] as Map<String, dynamic>
          : <String, dynamic>{};
      return PagedResult(
        items: items,
        page: (meta['page'] as num?)?.toInt() ?? 1,
        limit: (meta['limit'] as num?)?.toInt() ?? items.length,
        total: (meta['total'] as num?)?.toInt() ?? items.length,
        totalPages: (meta['total_pages'] as num?)?.toInt() ?? 1,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<T> delete<T>(String path, {T Function(dynamic raw)? parser}) async {
    try {
      final response = await _dio.delete(path);
      return _unwrap(response.data, parser: parser);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  T _unwrap<T>(dynamic body, {T Function(dynamic raw)? parser}) {
    if (body is! Map<String, dynamic>) {
      throw ApiException('Respons API tidak valid');
    }
    if (body['success'] != true) {
      throw ApiException(
        body['error']?.toString() ?? 'Terjadi kesalahan',
        details: body['details'] is Map<String, dynamic>
            ? body['details'] as Map<String, dynamic>
            : null,
      );
    }
    final data = body['data'];
    if (parser != null) return parser(data);
    return data as T;
  }

  ApiException _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return ApiException(
        data['error']?.toString() ?? 'Terjadi kesalahan',
        statusCode: status,
        details: data['details'] is Map<String, dynamic>
            ? data['details'] as Map<String, dynamic>
            : null,
      );
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiException('Koneksi timeout. Coba lagi.', statusCode: status);
    }
    if (e.type == DioExceptionType.connectionError) {
      return ApiException(
        'Tidak bisa terhubung ke server. Periksa API URL / ngrok.',
        statusCode: status,
      );
    }
    return ApiException(e.message ?? 'Terjadi kesalahan jaringan', statusCode: status);
  }
}

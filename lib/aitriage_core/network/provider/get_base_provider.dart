import 'package:get/get_connect.dart';
import '../../common/app_error.dart';
import '../base_response.dart';
import '../logging.dart';

class GetConnectBaseProvider extends GetConnect with ShowLog {
  final String url;
  final String apiVersion;
  final String apiPrefix;

  GetConnectBaseProvider({
    required this.url,
    this.apiVersion = '',
    this.apiPrefix = ''
  }) {
    timeout = const Duration(seconds: 15);
    allowAutoSignedCert = true;
    httpClient.baseUrl = '$url$apiPrefix$apiVersion';
    httpClient.errorSafety = true;

    // thứ tự các callback
    // authenticator -> requestModifier -> responseModifier

    httpClient.addAuthenticator<dynamic>((request) {
      return request;
    });

    httpClient.addRequestModifier<void>((request) async {
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      return response;
    });
  }

  T convertResponse<T extends BaseResponse>(Response response, T Function(dynamic) converter) {
    showResponse(response.body);

    if (response.isOk) {
      return converter.call(response.body);
    } else {
      throw AppError(
        errorType: AppErrorType.networkError,
        statusCode: response.statusCode ?? 0,
        message: response.body?['message'] ?? 'Empty message',
        body: response.body,
      );
    }
  }

  @override
  Future<Response<T>> get<T>(
      String url, {
        Map<String, String>? headers,
        String? contentType,
        Map<String, dynamic>? query,
        Decoder<T>? decoder
      }) {
    showRequest('${httpClient.baseUrl}$url${queryToString(query)}', null);
    return super.get(
        url,
        headers: headers,
        contentType:
        contentType,
        query: query,
        decoder: decoder
    );
  }

  @override
  Future<Response<T>> post<T>(
      String? url,
      body, {
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
        Progress? uploadProgress
      }) {
    showRequest('${httpClient.baseUrl}$url${queryToString(query)}', body);
    return super.post(
        url,
        body,
        contentType: contentType,
        headers: headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress
    );
  }

  @override
  Future<Response<T>> put<T>(
      String url,
      body, {
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
        Progress? uploadProgress
      }) {
    showRequest('${httpClient.baseUrl}$url${queryToString(query)}', body);
    return super.put(
        url, body,
        contentType: contentType,
        headers: headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress
    );
  }
}
import 'package:ancientpeoplemobile/common/common.dart';
import 'package:ancientpeoplemobile/utils/print_long.dart';
import 'package:dio/dio.dart';

class LogInterceptors extends InterceptorsWrapper {
  bool isDebug = AppConfig.isDebug;

  @override
  onRequest(RequestOptions options) async {
    if (isDebug) {
      StringBuffer stringBuffer = new StringBuffer();
      options.headers.forEach((key, value) {
        stringBuffer.write('\n $key:$value');
      });
    }
    return options;
  }

  @override
  onResponse(Response response) async {
    printKV('uri', response.request.uri);
    return response;
  }

  @override
  onError(DioError err) async {
    if (isDebug) {
      print('┌─────────────────────Begin Dio Error—————————————————————');
      printKV('error', err.toString());
      printKV('error message', (err.response?.toString() ?? ''));
      print('└—————————————————————End Dio Error———————————————————————\n\n');
    }
    return err;
  }

  printKV(String key, Object value) {
    printLong('$key: $value');
  }
}

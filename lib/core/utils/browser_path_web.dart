import 'package:flutter/services.dart';

String browserCurrentPath() => Uri.base.path.isEmpty ? '/' : Uri.base.path;

void browserReplacePath(String path, {Map<String, String>? queryParameters}) {
  final normalizedPath = path.startsWith('/') ? path : '/$path';
  final uri = Uri(
    path: normalizedPath,
    queryParameters: queryParameters == null || queryParameters.isEmpty
        ? null
        : queryParameters,
  );
  SystemNavigator.routeInformationUpdated(uri: uri, replace: true);
}

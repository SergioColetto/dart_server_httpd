import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

class HttpProxy {
  final HttpServer _server;
  final String path;

  HttpProxy._(this._server, this.path);
  String get host => _server.address.host;
  int get port => _server.port;
  String get urlBase => 'http://$host:$port/';

  static Future<HttpProxy> start({
    String? path,
    int port = 8080,
    Object address = 'localhost',
  }) async {
    path ??= Directory.current.path;

    final pipeline = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(createStaticHandler(path, defaultDocument: 'index.html'));

    final port = int.parse(Platform.environment['PORT'] ?? '8080');
    final server = await serve(pipeline, address, port);
    print('Server listening on port ${server.port}');
    return HttpProxy._(server, path);
  }

  Future<void> destroy() => _server.close();
}

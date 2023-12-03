import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

import 'options.dart';

void main(List<String> args) async {
  final options = parseOptions(args);

  final ip = InternetAddress.anyIPv4;
  final path = Directory.current.path;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(createStaticHandler(path, defaultDocument: 'index.html'));

  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

import 'package:args/args.dart';

class Options {
  final int? port;
  final String? path;
  final String? host;
  final bool help;

  Options({
    required this.port,
    this.path,
    required this.host,
    required this.help,
  });
}

Options parseOptionsResult(ArgResults result) => Options(
      port: int.tryParse(result['port'] as String) ??
          badNumberFormat(
            result['port'] as String,
            'int',
            'port',
          ),
      path: result['path'] as String?,
      host: result['host'] as String?,
      help: result['help'] as bool,
    );

ArgParser populateOptionsParser(ArgParser parser) => parser
  ..addOption(
    'port',
    abbr: 'p',
    help: 'The port to listen on.',
    valueHelp: 'port',
    defaultsTo: '8080',
  )
  ..addOption(
    'path',
    help: 'The path to serve. If not set, the current directory is used.',
    valueHelp: 'path',
  )
  ..addOption(
    'host',
    help: 'The hostname to listen on.',
    valueHelp: 'host',
    defaultsTo: 'localhost',
  )
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Displays the help.',
    negatable: false,
  );

final parserForOptions = populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = parserForOptions.parse(args);
  return parseOptionsResult(result);
}

T badNumberFormat<T extends num>(
  String source,
  String type,
  String argName,
) =>
    throw FormatException(
      'Cannot parse "$source" into `$type` for option "$argName".',
    );

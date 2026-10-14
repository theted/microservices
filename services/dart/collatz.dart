// One hailstone step from Dart, AOT-compiled to a native executable.
import 'dart:io';

int step(int n) => n.isEven ? n ~/ 2 : 3 * n + 1;

Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8000);
  print('Dart is listening on :8000');
  await for (final request in server) {
    final n = int.tryParse(request.uri.queryParameters['n'] ?? '');
    final response = request.response..headers.contentType = ContentType.text;
    if (n == null || n < 1) {
      response
        ..statusCode = HttpStatus.badRequest
        ..write('need ?n=<positive integer>');
    } else {
      response.write(step(n));
    }
    await response.close();
  }
}

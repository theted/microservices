// One hailstone step in Dart, compiled ahead of time to a native binary.
import 'dart:io';

int step(int n) => n.isEven ? n ~/ 2 : 3 * n + 1;

void main() => print(step(int.parse(stdin.readLineSync()!.trim())));

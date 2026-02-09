// this utility is used to generate random tokens,
// which can be used for various purposes like session management,
// unique identifiers, etc.

import 'dart:math';

const _base62chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

final _secureRandom = Random.secure();

String generate_token({int length = 12}) {
  final buffer = StringBuffer();
  for (int i = 0; i < length; i++) {
    buffer.write(_base62chars[_secureRandom.nextInt(62)]);
  }
  return buffer.toString();
}

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class CryptoUtils {
  static String generateRandomId() {
    final Random random = Random.secure();
    final Uint8List bytes = Uint8List(16);

    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }

    // Trim to length of 20
    return base64UrlEncode(bytes).substring(0, 20);
  }

  static String generateRandomUserCode() {
    final Random random = Random.secure();
    final List<int> randomBytes = List.generate(16, (_) => random.nextInt(256));
    final String hash = sha256.convert(randomBytes).toString().toUpperCase();

    return hash.substring(0, 12);
  }
}

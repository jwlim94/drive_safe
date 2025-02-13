import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

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
}

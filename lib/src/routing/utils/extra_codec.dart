import 'dart:convert';

class ExtraCodec extends Codec<Object?, Object?> {
  const ExtraCodec();

  @override
  Converter<Object?, Object?> get decoder => const _ExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _ExtraEncoder();
}

class _ExtraDecoder extends Converter<Object?, Object?> {
  const _ExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    final List<Object?> inputAsList = input as List<Object?>;
    if (inputAsList[0] == 'List<dynamic>') {
      return inputAsList[1] as List<dynamic>;
    } else if (inputAsList[0] == 'String') {
      return inputAsList[1] as String;
    }
    // Add more here if needed...
    throw FormatException('Unable to parse input: $input');
  }
}

class _ExtraEncoder extends Converter<Object?, Object?> {
  const _ExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    switch (input) {
      case List<dynamic> _:
        return <Object?>[
          'List<dynamic>',
          input,
        ];
      case String _:
        return <Object?>[
          'String',
          input,
        ];
      // Add more here if needed...
      default:
        throw FormatException('Cannot encode type ${input.runtimeType}');
    }
  }
}

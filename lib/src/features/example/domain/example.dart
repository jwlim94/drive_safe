// Example domain
class Example {
  final String exampleA;
  final String exampleB;
  final String? exampleC;

  const Example({
    required this.exampleA,
    this.exampleB = 'default string',
    this.exampleC,
  });
}

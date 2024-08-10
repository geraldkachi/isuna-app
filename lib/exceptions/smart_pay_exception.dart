// ignore_for_file: public_member_api_docs, sort_constructors_first
class MisauException implements Exception {
  final String? message;
  MisauException({
    this.message,
  });

  @override
  String toString() => 'MisauException(message: $message)';
}

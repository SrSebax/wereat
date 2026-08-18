class ServerException implements Exception {
  const ServerException([this.message = 'Error del servidor']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Error de cache']);

  final String message;
}

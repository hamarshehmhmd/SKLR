// Common model classes used across the database layer

/// Generic response model for database operations that return data
class DatabaseResponse {
  final bool success;
  final dynamic data;

  DatabaseResponse({
    required this.success,
    required this.data,
  });
}

/// Response model specifically for login/registration operations
class LoginResponse {
  final bool success;
  final String message;
  final dynamic userId;

  LoginResponse({
    required this.success,
    this.message = '',
    this.userId,
  });
}

/// Simple response model for operations that don't return data
class Response {
  final bool success;
  final String message;

  Response({
    required this.success,
    this.message = '',
  });
} 
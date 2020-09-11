class SignInException implements Exception {
  final String message;

  SignInException(this.message);
}

class SignUpException implements Exception {
  final String message;

  SignUpException(this.message);
}

class ForgotPasswordException implements Exception {
  final String message;

  ForgotPasswordException(this.message);
}

class CannotAddContactException implements Exception {
  final String message;

  CannotAddContactException(this.message);
}

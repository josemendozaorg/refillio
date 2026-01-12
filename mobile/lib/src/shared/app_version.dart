class AppVersion {
  /// The commit hash passed at build time, or 'dev' if not provided.
  static const String commitHash = String.fromEnvironment(
    'COMMIT_HASH', 
    defaultValue: 'dev'
  );

  /// The version from build time or default.
  static const String buildVersion = String.fromEnvironment(
    'BUILD_VERSION',
    defaultValue: '1.0.0'
  );
  
  static String get displayString => '$buildVersion ($commitHash)';
}

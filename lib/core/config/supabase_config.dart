class SupabaseConfig {
  const SupabaseConfig._();

  static const String _defaultSupabaseUrl =
      'https://gsmabdxgisjkveqdlzfq.supabase.co';
  static const String _defaultSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdzbWFiZHhnaXNqa3ZlcWRsemZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2MDAwNTQsImV4cCI6MjA3NzE3NjA1NH0.R-nWlO8ebXsx9x2sU8DGm6kfqSLNBdld5q6EJy63W5U';

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: _defaultSupabaseUrl,
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: _defaultSupabaseAnonKey,
  );
  static const String healthCheckTable = String.fromEnvironment(
    'SUPABASE_HEALTH_TABLE',
    defaultValue: 'profiles',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static void ensureConfigured() {
    if (!isConfigured) {
      throw StateError(
        'Missing Supabase credentials. Provide SUPABASE_URL and SUPABASE_ANON_KEY '
        'via --dart-define or replace placeholders in SupabaseConfig.',
      );
    }
  }
}

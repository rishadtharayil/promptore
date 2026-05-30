/// Runtime configuration for Promptore.
/// Values are injected at build time via --dart-define flags.
class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://pfrhclttfuhsrdwnildn.supabase.co',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmcmhjbHR0ZnVoc3Jkd25pbGRuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAxMzkxOTcsImV4cCI6MjA5NTcxNTE5N30.TtHvwEETY_fpdq-2-v8U-_dxrqF0wUz1nWAmldCs-Ek',
  );
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );
}

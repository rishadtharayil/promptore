import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/promptore_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Lock to portrait mode for the atmospheric mobile experience (only on non-web platforms)
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  runApp(const ProviderScope(child: PromptoreApp()));
}

/// PROMPTORE — A Living Archive of Human Imagination
class PromptoreApp extends ConsumerWidget {
  const PromptoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'PROMPTORE',
      debugShowCheckedModeBanner: false,
      theme: PromptoreTheme.lightTheme,
      darkTheme: PromptoreTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
      scrollBehavior: const AppScrollBehavior(),
    );
  }
}

/// Custom scroll behavior to allow mouse dragging on web and desktop
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

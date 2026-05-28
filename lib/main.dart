import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/promptore_theme.dart';
import 'core/router/app_router.dart';

import 'core/theme/colors.dart';
import 'core/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for the atmospheric mobile experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const ProviderScope(child: PromptoreApp()));
}

/// PROMPTORE — A Living Archive of Human Imagination
class PromptoreApp extends ConsumerWidget {
  const PromptoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isLight = themeMode == ThemeMode.light;

    // Sync global theme flag
    PromptoreTheme.isLight = isLight;

    // Immersive status bar dynamically adapting to light/dark
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: PromptoreColors.background,
        systemNavigationBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      ),
    );

    return MaterialApp.router(
      title: 'PROMPTORE',
      debugShowCheckedModeBanner: false,
      theme: PromptoreTheme.lightTheme,
      darkTheme: PromptoreTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}

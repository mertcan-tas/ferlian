import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ferlian/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'data/local/profile_local_data_source.dart';
import 'presentation/navigation/auth_gate.dart';
import 'presentation/providers/auth/auth_provider.dart';
import 'presentation/providers/ui/bottom_nav_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SupabaseConfig.ensureConfigured();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  await Hive.initFlutter();
  final profileStorage = ProfileLocalDataSource();
  await profileStorage.init();
  runApp(MyApp(profileStorage: profileStorage));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.profileStorage});

  final ProfileLocalDataSource profileStorage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseClient>(create: (_) => Supabase.instance.client),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            Supabase.instance.client,
            profileStorage: profileStorage,
          ),
        ),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (_) => BottomNavProvider(),
        ),
        Provider<ProfileLocalDataSource>.value(value: profileStorage),
      ],
      child: MaterialApp(
        title: 'Ferlian',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AuthGate(),
      ),
    );
  }
}

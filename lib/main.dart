import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'presentation/navigation/app_shell.dart';
import 'presentation/providers/bottom_nav_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SupabaseConfig.ensureConfigured();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseClient>(
          create: (_) => Supabase.instance.client,
        ),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (_) => BottomNavProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Ferlian',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0066FF)),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const AppShell(),
      ),
    );
  }
}

import 'package:akane_vote/app_router.dart';
import 'package:akane_vote/locator.dart';
import 'package:akane_vote/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: kSupabaseUrl,
    anonKey: kSupabaseApiKey,
  );

  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    closeLocator();
    super.dispose();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AQUANE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple, 
          primary: HexColor.fromHex(kPrimaryColor)
        ),
        useMaterial3: true,
      ),
      routerConfig: AppRouter().router,
      builder: (context, child) {
        // Retrieve the MediaQueryData from the current context.
        final mediaQueryData = MediaQuery.of(context);

        // Calculate the scaled text factor using the clamp function to ensure it stays within a specified range.
        final scale = mediaQueryData.textScaler.clamp(
          minScaleFactor: 1.0, // Minimum scale factor allowed.
          maxScaleFactor: 1.0, // Maximum scale factor allowed.
        );

        // return SafeArea(
        //   top: false,
        //   bottom: true,
        //   child: MediaQuery(
        //     data: mediaQueryData.copyWith(
        //       textScaler: scale,
        //     ),
        //     child: child!
        //   ),
        // );

        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: scale,
          ),
          child: child!
        );
      },
    );
  }
}


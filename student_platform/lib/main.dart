import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'di/injection_container.dart' as di;
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/student/attempt_status/attempt_status_cubit.dart';
import 'package:student_platform/core/screens/splash_screen.dart';
import 'package:student_platform/core/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }
  final auth = sl<AuthService>();
  final studentId = await auth.getUserId();

  if (studentId != null) {
    print(studentId);
    await sl<AttemptStatusCubit>().loadFromCache(studentId);
    await sl<AttemptStatusCubit>().loadFromBackend(studentId);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      localeResolutionCallback: (locale, supportedLocales) => const Locale('ar'),
      title: 'منصة الطالب',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(),
    );
  }
}

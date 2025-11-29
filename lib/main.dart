import 'package:attendance/firebase_options.dart';
import 'package:attendance/presentation/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:attendance/presentation/bloc/shop_bloc/shop_bloc.dart';
import 'package:attendance/presentation/screens/splash_screen/splash_screen.dart';
import 'package:attendance/service_locator/service_locater.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await initializeDependencies();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Failed to initialize Firebase: $e')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopBloc>(create: (context) => sl<ShopBloc>()),
        BlocProvider<AttendanceBloc>(create: (context) => sl<AttendanceBloc>()),
      ],
      child: MaterialApp(
        title: 'Attendance App',
        theme: ThemeData(),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_verse/features/auth/screens/splash_screen.dart';
import 'package:user_verse/features/home/bloc/home_bloc.dart';

import 'features/auth/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
      .whenComplete(() => print('Initialisation Completed...'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:  (context) => AuthBloc()),
        BlocProvider(create:  (context) => HomeBloc()),
      ],
      child: BlocProvider(
        create: (context)=>HomeBloc(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UserVerse',
          home: SplashScreen(),
        ),
      ),
    );
  }
}

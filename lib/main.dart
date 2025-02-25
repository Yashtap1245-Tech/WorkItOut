import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workout_provider.dart';
import 'workout_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final workoutProvider = WorkoutProvider();
  await workoutProvider.loadInitialData();

  await ensureAnonymousSignIn();

  runApp(MyApp(workoutProvider: workoutProvider));
}

Future<void> ensureAnonymousSignIn() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    await auth.signInAnonymously();
  }
}

class MyApp extends StatelessWidget {
  final WorkoutProvider workoutProvider;

  const MyApp({super.key, required this.workoutProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: workoutProvider,
      child: MaterialApp(
        title: 'Workout App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
          useMaterial3: true,
        ),
        home: WorkoutHistoryPage(),
      ),
    );
  }
}
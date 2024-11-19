import 'package:adv_exam/provider/provider.dart';
import 'package:adv_exam/view/SignIn.dart';
import 'package:adv_exam/view/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ExpenseProvider(),
        )
      ],
      builder: (context, child) =>
          MaterialApp(debugShowCheckedModeBanner: false, home:Signin()),
    );
  }
}

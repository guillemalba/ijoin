import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ijoin/screens/ProfilePage.dart';
import 'package:ijoin/screens/home.dart';
import 'package:ijoin/screens/login.dart';
import 'package:ijoin/screens/notifier.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<MultipleNotifier>(
          create: (_) => MultipleNotifier([]),
        )
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I Join App ',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
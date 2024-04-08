import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_package_call/list_solicitantes.dart';
import 'package:test_package_call/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: ListSolicitantes.route,
      onGenerateRoute: onGenerateRoute,
    );
  }
}

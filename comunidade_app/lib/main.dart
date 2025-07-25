import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/home_page.dart';

void main() async {
  await initializeDateFormatting('pt_BR', null); // Inicializa o locale
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Login automático com usuário padrão
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'padrao@app.com',
      password: 'senha123',
    );
  } catch (e) {
    // Silencia erro se usuário já estiver logado ou outro erro não crítico
    if (kDebugMode) {
      debugPrint('Erro ao logar automaticamente: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Rural',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

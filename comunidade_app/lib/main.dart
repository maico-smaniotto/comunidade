import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Login automático com usuário padrão
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'padrao@app.com',
      password: 'senha123',
    );
  } catch (e) {
    // Silencia erro se usuário já estiver logado ou outro erro não crítico
    print('Erro ao logar automaticamente: $e');
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

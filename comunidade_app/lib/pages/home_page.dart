import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String emailLogado = "";
    final user = FirebaseAuth.instance.currentUser;

    if (user?.email != null) {
      emailLogado = user?.email as String;
    }
    emailLogado = "administrador@comunidadeapp.com.br";

    // final isAdmin = user != null && user.email == "administrador@comunidade.com.br";

    final isAdmin = emailLogado == "administrador@comunidadeapp.com.br";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página inicial'),
        actions: [
          if (!isAdmin) ...[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text(
                'Entrar como Admin',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16
                ),
              ),
            ),
          ] else ...[          
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Após logout, pode fazer login automático de novo
                // await FirebaseAuth.instance.signInWithEmailAndPassword(
                //   email: 'padrao@app.com',
                //   password: 'senha123',
                // );
                // Recarrega a Home
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              },
            ),
          ]
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [                
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: onPrevisaoDoTempoPressed, 
                    child: Text(
                      '🌤️  Previsão do tempo',
                      style: TextStyle(
                        fontSize: 18
                      )
                    )
                  )
                ),
              ]
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: onCotacoesPressed, 
                    child: const Text(
                      '📈  Cotações agrícolas',
                      // '🌾🌱  Cotações agrícolas',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    )
                  ),
                ),                
              ],
            ),
            
            const SizedBox(height: 10),
            
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),                      
                    ),
                    onPressed: onAvisosPressed, 
                    child: const Text(
                      '📢  Avisos',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    )
                  ),
                ),
              ],
            ),
            
            Spacer(),

            if (isAdmin) ...[
              const SizedBox(height: 10),
              Center(
                child: Text(emailLogado),
              ),
            ],

            const SizedBox(height: 10),
            Center(
              child: Text("v0.1-alpha"),
            )

          ],
        ),
      ),
    );
  }

  void onPrevisaoDoTempoPressed() {    
    print('Previsão do tempo pressionado');
  }

  void onCotacoesPressed() {    
    print('Cotações pressionado');
  }

  void onAvisosPressed() {    
    print('Avisos pressionado');
  }

}

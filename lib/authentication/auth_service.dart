import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> entrarUsuario(
      {required String email, required String senha}) async {
    try {
      final UserCredential cred = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: senha);

      final User? user = cred.user;

      if (user != null) {
        final displayName = user.displayName ?? 'Usuário';
        
        salvarNomeLocal(displayName, email);

        // ✅ Login bem-sucedido, retorna null (sem erro)
      } else {
        return 'Erro ao obter dados do usuário';
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-credential":
          return "email ou senha inválidos";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> cadastraUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await userCredential.user!.updateDisplayName(nome);
      salvarNomeLocal(nome, email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return "O e-mail já está em uso.";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> redefinicaoSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> deslogar() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> salvarNomeLocal(String nome, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', nome);
    await prefs.setString('email', email);
  }
}

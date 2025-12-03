import '../models/usuario.dart';

class AuthController {
  // Singleton
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal();

  // Usuário logado
  static Usuario? usuarioLogado;

  // Getter para singleton
  static AuthController get instance => _instance;

  // Salvar usuário no login
  static void login(Usuario usuario) {
    usuarioLogado = usuario;
  }

  // Sair
  static void logout() {
    usuarioLogado = null;
  }

  // Verificar se tem usuário logado
 static bool get isLogged => usuarioLogado != null;
}

import 'package:flutter/material.dart';
import 'package:projeto_app_livros/controllers/authControlles.dart';
import 'package:projeto_app_livros/pages/adicionar_livro_page.dart';
import 'package:projeto_app_livros/pages/listar_livro_page.dart';
import 'package:projeto_app_livros/pages/listar_resenha_page.dart';
import 'package:projeto_app_livros/pages/login/login_page.dart';
import 'package:projeto_app_livros/pages/pesquisar_livro_page.dart';
import 'package:projeto_app_livros/themes/colors.dart';
import 'package:projeto_app_livros/themes/text_style.dart';
import '../widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool carregando = true;
  late int userId;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final user = AuthController.usuarioLogado;
    if (user != null) {
      userId = user.id!;
    } else {
      userId = 0;
    }

    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      carregando = false;
    });
  }

  void _logout() {
    AuthController.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.white,
            strokeWidth: 3,
          ),
        ),
      );
    }

    final cardStyle = BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4,
          offset: Offset(2, 2),
        ),
      ],
    );

    return Scaffold(
      appBar: const CustomAppBar(title: "App Livros"),
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Grid de cards centralizados
          Expanded(
            child: Center(
              child: GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2,
                children: [
                  _buildCard(Icons.add, "Adicionar Livro", cardStyle, context),
                  _buildCard(Icons.list, "Minha Lista", cardStyle, context),
                  _buildCard(Icons.rate_review, "Resenhas", cardStyle, context),
                  _buildCard(Icons.search, "Pesquisar Livro", cardStyle, context),
                ],
              ),
            ),
          ),

          // Botão de logout com texto e ícone em vermelho
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String label, BoxDecoration style, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "Adicionar Livro") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdicionarLivroPage(idUsuario: userId),
            ),
          );
        } else if (label == "Minha Lista") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListarLivroPage(idUsuario: userId),
            ),
          );
        } else if (label == "Resenhas") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListarResenhasPage(idUsuario: userId),
            ),
          );
        } else if (label == "Pesquisar Livro") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PesquisarLivroPage(idUsuario: userId),
            ),
          );
        }
      },
      child: Container(
        decoration: style,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 30),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.title.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

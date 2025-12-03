import 'package:flutter/material.dart';
import 'package:projeto_app_livros/pages/adicionar_livro_page.dart';
import 'package:projeto_app_livros/pages/listar_livro_page.dart';
import 'package:projeto_app_livros/pages/listar_resenha_page.dart';
import 'package:projeto_app_livros/pages/pesquisar_livro_page.dart';
import 'package:projeto_app_livros/themes/colors.dart';
import 'package:projeto_app_livros/themes/text_style.dart';
import '../widgets/custom_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3 / 2, // largura / altura, menor valor = card mais alto
          children: [
            _buildCard(Icons.add, "Adicionar Livro", cardStyle, context),
            _buildCard(Icons.list, "Minha Lista", cardStyle, context),
            _buildCard(Icons.rate_review, "Resenhas", cardStyle, context),
            _buildCard(Icons.search, "Pesquisar Livro", cardStyle, context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String label, BoxDecoration style, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "Adicionar Livro") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => const AdicionarLivroPage()),
          );
        }else if (label == "Minha Lista") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => ListarLivroPage(),),
      );
        }else if (label == "Resenhas") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => ListarResenhasPage(),),
      );
        }else if (label == "Pesquisar Livro") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => PesquisarLivroPage(),),
      );
        }
      },
      child: Container(
        decoration: style,
        padding: const EdgeInsets.all(8), // diminui o espaço interno
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 30), // ícone menor
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.title.copyWith(fontSize: 14), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

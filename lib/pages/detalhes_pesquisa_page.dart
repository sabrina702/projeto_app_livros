import 'package:flutter/material.dart';
import 'package:projeto_app_livros/themes/colors.dart';
import 'package:projeto_app_livros/widgets/custom_appbar.dart';

class InformacoesLivroPage extends StatelessWidget {
  final Map<String, dynamic> livro;

  const InformacoesLivroPage({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(title: livro["titulo"] ?? "Detalhes do Livro"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGEM DO LIVRO
            Center(
              child: livro["thumbnail"] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        livro["thumbnail"],
                        height: 220,
                      ),
                    )
                  : const Icon(Icons.book, size: 120, color: Colors.white),
            ),

            const SizedBox(height: 24),

            // TÍTULO
            Text(
              livro["titulo"] ?? "Sem título",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 8),

            // AUTOR
            Text(
              "Autor: ${livro["autor"] ?? "Desconhecido"}",
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 12),

            // PÁGINAS
            Text(
              "Páginas: ${livro["paginas"]}",
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 20),

            // DESCRIÇÃO
            const Text(
              "Descrição",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              livro["descricao"]?.isNotEmpty == true
                  ? livro["descricao"]
                  : "Sem descrição disponível.",
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

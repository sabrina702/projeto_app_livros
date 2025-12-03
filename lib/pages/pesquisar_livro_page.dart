import 'package:flutter/material.dart';
import 'package:projeto_app_livros/pages/detalhes_pesquisa_page.dart';
import 'package:projeto_app_livros/service/google_books_service.dart';
import 'package:projeto_app_livros/themes/colors.dart';
import 'package:projeto_app_livros/widgets/custom_appbar.dart';

class PesquisarLivroPage extends StatefulWidget {
  const PesquisarLivroPage({super.key});

  @override
  State<PesquisarLivroPage> createState() => _PesquisarLivroPageState();
}

class _PesquisarLivroPageState extends State<PesquisarLivroPage> {
  List<Map<String, dynamic>> resultados = [];
  bool carregando = false;
  final controller = TextEditingController();

  void buscar() async {
    String texto = controller.text.trim();
    if (texto.isEmpty) return;

    setState(() => carregando = true);

    try {
      resultados = await GoogleBooksService.buscarLivros(texto);
    } catch (e) {
      resultados = [];
    }

    setState(() => carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: const CustomAppBar(title: "Pesquisar Livro"),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CAMPO DE PESQUISA (branco)
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Pesquisar livro...",
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: AppColors.primary),
                    onPressed: buscar,
                  ),
                ),
                onSubmitted: (_) => buscar(),
              ),
            ),

            const SizedBox(height: 20),

            // LOADING
            if (carregando)
              const CircularProgressIndicator(color: AppColors.white),

            const SizedBox(height: 12),

            // LISTA DE RESULTADOS
            Expanded(
              child: ListView.builder(
                itemCount: resultados.length,
                itemBuilder: (_, index) {
                  final livro = resultados[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: livro["thumbnail"] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                livro["thumbnail"],
                                width: 55,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.book, color: AppColors.primary),

                      title: Text(
                        livro["titulo"],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      subtitle: Text(
                        livro["autor"],
                        style: const TextStyle(color: AppColors.primary),
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InformacoesLivroPage(livro: livro),
                          ),
                        );
                      }

                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

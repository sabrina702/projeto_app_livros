import 'package:flutter/material.dart';
import '../database/livroDAO.dart';
import '../models/livro.dart';
import '../widgets/custom_appbar.dart';
import '../themes/colors.dart';
import 'informacoes_livro_page.dart';

class ListarLivroPage extends StatefulWidget {
  const ListarLivroPage({super.key});

  @override
  State<ListarLivroPage> createState() => _ListarLivroPageState();
}

class _ListarLivroPageState extends State<ListarLivroPage> {
  List<Livro> livros = [];

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    final lista = await LivroDAO.getAll();
    setState(() {
      livros = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Minha Lista"),
      backgroundColor: AppColors.primary,
      body: livros.isEmpty
          ? const Center(
              child: Text(
                "Nenhum livro cadastrado",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                final livro = livros[index];

                return Card(
                  color: Colors.white, // fundo branco
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      livro.titulo,
                      style: const TextStyle(
                        color: Colors.blue, // título azul
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InformacoesLivroPage(livro: livro),
                        ),
                      );

                      // Se editou ou apagou, recarrega a lista
                      if (result == true) {
                        _carregarLivros();
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}

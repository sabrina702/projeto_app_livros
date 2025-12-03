import 'package:flutter/material.dart';
import '../database/livroDAO.dart';
import '../models/livro.dart';
import '../widgets/custom_appbar.dart';
import '../themes/colors.dart';
import 'informacoes_livro_page.dart';
import '../controllers/authControlles.dart';

class ListarLivroPage extends StatefulWidget {
  final int idUsuario;

  const ListarLivroPage({super.key, required this.idUsuario});

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
    if (!AuthController.isLogged) return;

    final usuarioId = AuthController.usuarioLogado!.id!;
    final lista = await LivroDAO.getAllByUsuario(usuarioId); // Filtra pelo usuário logado
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
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      livro.titulo,
                      style: const TextStyle(
                        color: Colors.blue,
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
                          builder: (_) => InformacoesLivroPage(livro: livro),
                        ),
                      );

                      if (result == true) {
                        _carregarLivros(); // Atualiza lista se houver alterações
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}

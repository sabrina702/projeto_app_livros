import 'package:flutter/material.dart';
import 'package:projeto_app_livros/database/resenhaDAO.dart';
import 'package:projeto_app_livros/models/resenha.dart';
import 'package:projeto_app_livros/pages/adicionar_resenha_page.dart';
import 'package:projeto_app_livros/themes/colors.dart';
import 'package:projeto_app_livros/widgets/custom_appbar.dart';

class ListarResenhasPage extends StatefulWidget {
  const ListarResenhasPage({super.key});

  @override
  State<ListarResenhasPage> createState() => _ListarResenhasPageState();
}

class _ListarResenhasPageState extends State<ListarResenhasPage> {
  List<Resenha> _resenhas = [];

  @override
  void initState() {
    super.initState();
    _carregarResenhas();
  }

  Future<void> _carregarResenhas() async {
    final lista = await ResenhaDAO.findAll();
    setState(() {
      _resenhas = lista;
    });
  }

  Future<void> _abrirNovaResenha() async {
    final adicionou = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdicionarResenhaPage()),
    );

    if (adicionou == true) {
      _carregarResenhas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🔵 Custom App Bar
      appBar: const CustomAppBar(title: "Resenhas"),
      backgroundColor: AppColors.primary,
      // ➕ Botão flutuante personalizado
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirNovaResenha,
        backgroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: AppColors.primary),
      ),

      body: _resenhas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma resenha cadastrada",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _resenhas.length,
              itemBuilder: (context, index) {
                final r = _resenhas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  color: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      r.nomeLivro,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Avaliação: ${r.avaliacao}/5\n${r.descricao}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

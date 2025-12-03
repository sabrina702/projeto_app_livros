import 'package:flutter/material.dart';
import 'package:projeto_app_livros/controllers/authControlles.dart';
import '../database/livroDAO.dart';
import '../models/livro.dart';
import '../widgets/custom_appbar.dart';
import '../themes/colors.dart';

class InformacoesLivroPage extends StatefulWidget {
  final Livro livro;
  const InformacoesLivroPage({super.key, required this.livro});

  @override
  State<InformacoesLivroPage> createState() => _InformacoesLivroPageState();
}

class _InformacoesLivroPageState extends State<InformacoesLivroPage> {
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _paginasController;
  late TextEditingController _resenhaController;
  late String _status;
  late int idUsuario;

  @override
  void initState() {
    super.initState();
    final user = AuthController.usuarioLogado;
    idUsuario = user?.id ?? 0;

    _tituloController = TextEditingController(text: widget.livro.titulo);
    _autorController = TextEditingController(text: widget.livro.autor);
    _paginasController =
        TextEditingController(text: widget.livro.paginas.toString());
    _resenhaController = TextEditingController();
    _status = widget.livro.status;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _paginasController.dispose();
    _resenhaController.dispose();
    super.dispose();
  }

  void _editarLivro() async {
    final paginas = int.tryParse(_paginasController.text);
    if (paginas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Número de páginas inválido"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Apenas atualiza o status, mantendo os outros dados
    final livroAtualizado = Livro(
      id: widget.livro.id,
      titulo: widget.livro.titulo,
      autor: widget.livro.autor,
      paginas: widget.livro.paginas,
      status: _status,
      idUsuario: idUsuario, // 🔑 vincula ao usuário logado
    );

    final result = await LivroDAO.update(livroAtualizado);
    if (result != -1) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Livro atualizado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao atualizar livro"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deletarLivro() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmação"),
        content: const Text("Deseja realmente excluir este livro?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Não")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sim")),
        ],
      ),
    );

    if (confirm == true) {
      final result = await LivroDAO.delete(widget.livro.id!);
      if (result != -1) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Livro excluído com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao excluir livro"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Informações do Livro"),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Título"),
            _buildTextField(_tituloController, readOnly: true),
            const SizedBox(height: 12),

            _buildLabel("Autor"),
            _buildTextField(_autorController, readOnly: true),
            const SizedBox(height: 12),

            _buildLabel("Número de páginas"),
            _buildTextField(_paginasController, readOnly: true, isNumber: true),
            const SizedBox(height: 12),

            _buildLabel("Status"),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrayBlue,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  items: ["Quero Ler", "Lendo", "Lido", "Abandonado"]
                      .map((status) =>
                          DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _editarLivro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Editar",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deletarLivro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Excluir",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      {bool isNumber = false, bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightGrayBlue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

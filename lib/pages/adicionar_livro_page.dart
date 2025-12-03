import 'package:flutter/material.dart';
import 'package:projeto_app_livros/database/livroDAO.dart';
import '../themes/colors.dart';
import '../models/livro.dart';
import '../widgets/custom_appbar.dart';

class AdicionarLivroPage extends StatefulWidget {
  const AdicionarLivroPage({super.key});

  @override
  State<AdicionarLivroPage> createState() => _AdicionarLivroPageState();
}

class _AdicionarLivroPageState extends State<AdicionarLivroPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _paginasController = TextEditingController();
  final TextEditingController _resenhaController = TextEditingController();

  String _status = "Quero Ler"; // valor padrão

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Adicionar Livro"),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Título"),
              _buildTextField(_tituloController, true),
              const SizedBox(height: 12),

              _buildLabel("Autor"),
              _buildTextField(_autorController, true),
              const SizedBox(height: 12),

              _buildLabel("Número de páginas"),
              _buildTextField(_paginasController, true, isNumber: true),
              const SizedBox(height: 12),

              _buildLabel("Resenha (opcional)"),
              _buildTextField(_resenhaController, false, maxLines: 4),
              const SizedBox(height: 12),

              _buildLabel("Status"),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGrayBlue,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ["Quero Ler", "Lendo", "Lido", "Abandonado"]
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              Center(
                child: SizedBox(
                  width: double.infinity, // botão largo
                  child: ElevatedButton(
                    onPressed: _salvarLivro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool required,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return "Campo obrigatório";
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightGrayBlue, // azul acizentado
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  void _salvarLivro() async {
    if (_formKey.currentState!.validate()) {
      try {
        final novoLivro = Livro(
          titulo: _tituloController.text,
          autor: _autorController.text,
          paginas: int.parse(_paginasController.text),
          status: _status,
        );

        await LivroDAO.insert(novoLivro);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Livro salvo com sucesso!"), backgroundColor: Colors.green),
        );

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context, true); // volta para a home
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao salvar o livro"), backgroundColor: Colors.red),
        );
      }
    }
  }
}

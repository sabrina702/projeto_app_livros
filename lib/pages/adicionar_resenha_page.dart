import 'package:flutter/material.dart';
import 'package:projeto_app_livros/database/resenhaDAO.dart';
import 'package:projeto_app_livros/models/resenha.dart';
import 'package:projeto_app_livros/themes/colors.dart';
import 'package:projeto_app_livros/widgets/custom_appbar.dart';

class AdicionarResenhaPage extends StatefulWidget {
  const AdicionarResenhaPage({super.key});

  @override
  State<AdicionarResenhaPage> createState() => _AdicionarResenhaPageState();

  
}

class _AdicionarResenhaPageState extends State<AdicionarResenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeLivroController = TextEditingController();
  final _descricaoController = TextEditingController();
  double _avaliacao = 0;

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final resenha = Resenha(
        nomeLivro: _nomeLivroController.text,
        descricao: _descricaoController.text,
        avaliacao: _avaliacao,
      );

      final result = await ResenhaDAO.insert(resenha);

      if (result != -1) {
        Navigator.pop(context, true);
      }
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.lightGrayBlue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.white, width: 2),
      ),
    );
  }

  Widget _buildStarRating() {
  return Row(
    children: List.generate(5, (index) {
      return IconButton(
        onPressed: () {
          setState(() {
            _avaliacao = index + 1;
          });
        },
        icon: Icon(
          Icons.star,
          size: 32,
          color: (index < _avaliacao)
              ? Colors.yellow
              : Colors.white.withOpacity(0.4),
        ),
      );
    }),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: const CustomAppBar(title: "Nova Resenha"),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Label
                const Text(
                  "Nome do Livro",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                // Input
                TextFormField(
                  controller: _nomeLivroController,
                  decoration: _inputDecoration(),
                  validator: (value) =>
                      value!.isEmpty ? "Informe o nome do livro" : null,
                ),
                const SizedBox(height: 16),

                // Label
                const Text(
                  "Descrição",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                // Input descrição
                TextFormField(
                  controller: _descricaoController,
                  maxLines: 5,
                  decoration: _inputDecoration(),
                  validator: (value) =>
                      value!.isEmpty ? "Informe a descrição" : null,
                ),
                const SizedBox(height: 20),

                // Label avaliação
                const Text(
                  "Avaliação (0 a 5)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),

                Slider(
                  min: 0,
                  max: 5,
                  divisions: 5,
                  value: _avaliacao,
                  label: _avaliacao.toString(),
                  activeColor: AppColors.white,
                  onChanged: (value) {
                    setState(() {
                      _avaliacao = value;
                    });
                  },
                ),

                const SizedBox(height: 8),
                _buildStarRating(),


                // Botão salvar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

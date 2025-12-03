import 'package:flutter/material.dart';
import 'package:projeto_app_livros/themes/colors.dart';
import 'package:projeto_app_livros/themes/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: AppBar(
          title: Text(title, style: AppTextStyles.appBarTitle),
          backgroundColor: Colors.transparent, // transparente para respeitar o Container
          centerTitle: true,
          elevation: 0, // remove sombra do AppBar
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

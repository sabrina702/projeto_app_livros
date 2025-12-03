import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  static const String baseUrl = "https://www.googleapis.com/books/v1/volumes";

  static Future<List<Map<String, dynamic>>> buscarLivros(String query) async {
    final url = Uri.parse("$baseUrl?q=$query&maxResults=20");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar livros na API");
    }

    final data = jsonDecode(response.body);

    if (data["items"] == null) return [];

    List<Map<String, dynamic>> livros = [];

    for (var item in data["items"]) {
      final volume = item["volumeInfo"];

      livros.add({
        "titulo": volume["title"] ?? "Sem título",
        "autor": volume["authors"] != null
            ? (volume["authors"] as List).join(", ")
            : "Autor desconhecido",
        "paginas": volume["pageCount"] ?? 0,
        "descricao": (volume["description"] ?? "").toString(),
        "thumbnail": volume["imageLinks"]?["thumbnail"] ??
                     volume["imageLinks"]?["smallThumbnail"],
      });
    }

    return livros;
  }
}

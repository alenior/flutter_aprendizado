import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cep_model.dart';

class CepService {
  final String apiUrl = 'https://viacep.com.br/ws';

  Future<Cep> fetchCep(String cep) async {
    final response = await http.get(Uri.parse('$apiUrl/$cep/json/'));

    if (response.statusCode == 200) {
      return Cep.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load CEP data');
    }
  }
}
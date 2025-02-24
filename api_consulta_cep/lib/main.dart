import 'package:flutter/material.dart';
import 'cep_service.dart';
import 'cep_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP - Desenvolvido por Alencar Júnior',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CepConsulta(),
    );
  }
}

class CepConsulta extends StatefulWidget {
  const CepConsulta({super.key});

  @override
  CepConsultaState createState() => CepConsultaState();
}

class CepConsultaState extends State<CepConsulta> {
  final _cepController = TextEditingController();
  Cep? _cep;
  String _errorMessage = '';

  final CepService _cepService = CepService();

  void _consultarCep() async {
    final cep = _cepController.text;
    if (cep.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, insira um CEP válido.';
      });
      return;
    }

    try {
      final cepData = await _cepService.fetchCep(cep);
      setState(() {
        _cep = cepData;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao consultar o CEP. Verifique o CEP e tente novamente.';
        _cep = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta CEP - Alencar Júnior'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              decoration: InputDecoration(
                labelText: 'CEP',
                hintText: 'Digite o CEP',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _consultarCep,
              child: Text('Consultar'),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            if (_cep != null)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CEP: ${_cep!.cep}'),
                        Text('Logradouro: ${_cep!.logradouro}'),
                        Text('Complemento: ${_cep!.complemento}'),
                        Text('Bairro: ${_cep!.bairro}'),
                        Text('Localidade: ${_cep!.localidade}'),
                        Text('UF: ${_cep!.uf}'),
                        Text('IBGE: ${_cep!.ibge}'),
                        Text('GIA: ${_cep!.gia}'),
                        Text('DDD: ${_cep!.ddd}'),
                        Text('SIAFI: ${_cep!.siafi}'),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
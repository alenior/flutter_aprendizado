import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:brasil_fields/brasil_fields.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário com Validações',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _moneyController = TextEditingController();

  // Máscara para data (dd-mm-aaaa)
  final _dateMaskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Máscara para CPF (000.000.000-00)
  final _cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _dateController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  bool _validateDate(String date) {
    final RegExp dateRegExp = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!dateRegExp.hasMatch(date)) {
      return false;
    }

    final parts = date.split('-');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return false;
    }

    if (month < 1 || month > 12) {
      return false;
    }

    if (day < 1 || day > 31) {
      return false;
    }

    // Verificação básica de meses com 30 dias
    if ((month == 4 || month == 6 || month == 9 || month == 11) && day > 30) {
      return false;
    }

    // Verificação de fevereiro e anos bissextos
    if (month == 2) {
      final isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      if (day > 29 || (day == 29 && !isLeapYear)) {
        return false;
      }
    }

    return true;
  }

  bool _validateEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  bool _validateCPF(String cpf) {
    return CPFValidator.isValid(cpf);
  }

  bool _validateMoney(String money) {
    // Remove o símbolo "R$" e vírgulas para validar o valor numérico
    final numericValue = money.replaceAll(RegExp(r'[^0-9]'), '');
    final value = double.tryParse(numericValue) ?? 0;
    return value > 0;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Formulário válido!')),
      );
    }
  }

  void _formatMoney(String value) {
    // Remove todos os caracteres não numéricos
    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Converte para double e divide por 100 para considerar os centavos
    final doubleValue = double.tryParse(numericValue) ?? 0;
    final formattedValue = (doubleValue / 100).toStringAsFixed(2);

    // Atualiza o texto do campo com o valor formatado
    _moneyController.value = TextEditingValue(
      text: 'R\$ $formattedValue',
      selection: TextSelection.collapsed(
        offset: 'R\$ $formattedValue'.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário com Validações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Data (dd-mm-aaaa)'),
                inputFormatters: [_dateMaskFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma data';
                  }
                  if (!_validateDate(value)) {
                    return 'Data inválida';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                  if (!_validateEmail(value)) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
                inputFormatters: [_cpfMaskFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um CPF';
                  }
                  if (!_validateCPF(value)) {
                    return 'CPF inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _moneyController,
                decoration: InputDecoration(labelText: 'Valor Monetário'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  _formatMoney(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor monetário';
                  }
                  if (!_validateMoney(value)) {
                    return 'Valor monetário inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
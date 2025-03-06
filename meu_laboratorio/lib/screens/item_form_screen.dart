import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; // Para salvar em diretório específico
import 'package:flutter/services.dart'; // Para usar Process.run
import '../models/item.dart';
import '../database/database_helper.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;

  const ItemFormScreen({super.key, this.item});

  @override
  ItemFormScreenState createState() => ItemFormScreenState();
}

class ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _quantityController = TextEditingController();
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Solicita permissões ao iniciar

    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _descriptionController.text = widget.item!.description;
      _valueController.text =
          widget.item!.value.toStringAsFixed(2).replaceAll('.', ',');
      _quantityController.text = widget.item!.quantity.toString();
      _imagePath = widget.item!.imagePath;
    }
  }

  Future<void> _requestPermissions() async {
    // Solicita permissões para câmera, armazenamento e fotos
    await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
  }

  Future<void> _pickImage(ImageSource source) async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissão da câmera negada")),
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        // Salvar a imagem no diretório adequado
        await _saveImageToStorage(pickedFile.path);
        setState(() {
          _imagePath = pickedFile.path;
          debugPrint("Imagem salva em: $_imagePath");
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Nenhuma imagem selecionada")),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint("Erro ao acessar a câmera: $e");
      debugPrint(stackTrace.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao acessar a câmera")),
        );
      }
    }
  }

  Future<void> _saveImageToStorage(String imagePath) async {
    try {
      // Obter o diretório externo onde a imagem será salva
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao acessar o diretório")),
        );
        return;
      }

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final newImagePath = '${directory.path}/$fileName.jpg';
      final imageFile = File(imagePath);

      // Salvar a imagem no novo diretório
      await imageFile.copy(newImagePath);

      // Adicionar a imagem à galeria
      await _addImageToGallery(newImagePath);

      setState(() {
        _imagePath = newImagePath;
      });

      debugPrint("Imagem salva em: $newImagePath");
    } catch (e) {
      debugPrint("Erro ao salvar a imagem: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao salvar a imagem")),
      );
    }
  }

  Future<void> _addImageToGallery(String imagePath) async {
    try {
      final File imageFile = File(imagePath);

      // Adicionando a imagem à galeria (via MediaScannerConnection)
      await imageFile.exists().then((exists) async {
        if (exists) {
          final result = await Process.run(
              'am',
              ['broadcast', '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE', 'file://$imagePath'],
              runInShell: true);
          debugPrint('Imagem adicionada à galeria: $result');
        }
      });
    } catch (e) {
      debugPrint("Erro ao adicionar imagem à galeria: $e");
    }
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      Item newItem = Item(
        id: widget.item?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        value: double.parse(_valueController.text.replaceAll(',', '.')),
        quantity: int.parse(_quantityController.text),
        imagePath: _imagePath,
      );

      try {
        if (widget.item == null) {
          await DatabaseHelper().insertItem(newItem);
        } else {
          await DatabaseHelper().updateItem(newItem);
        }

        if (mounted) {
          Navigator.pop(context, true); // Garante que só volta se o widget ainda estiver ativo
        }
      } catch (e) {
        debugPrint("Erro ao salvar item: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro ao salvar item")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Adicionar Item' : 'Editar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                autocorrect: true,
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixText: 'R\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _imagePath.isNotEmpty
                  ? Image.file(File(_imagePath), height: 100)
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Text('Galeria'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Text('Câmera'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _saveItem, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}

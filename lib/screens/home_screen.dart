import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:chat_con_ia_integrada/services/ai_service.dart';
import 'package:chat_con_ia_integrada/widgets/code_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _generatedCode = "";
  bool _isLoading = false;

  void _copyToClipboard() {
    if (_generatedCode.isNotEmpty) {
      FlutterClipboard.copy(_generatedCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código copiado al portapapeles"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _generateCode() async {
    setState(() {
      _isLoading = true;
    });

    final description = _controller.text.trim();
    if (description.isEmpty) return;

    final code = await AiServices.generateCode(description);

    setState(() {
      _generatedCode = code;
      _isLoading = false;
    });

    _controller.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Generador de Código AI",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: "Describe lo que quieres...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _generateCode,
                  icon: const Icon(Icons.smart_toy),
                  label: const Text("Generar Código"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text("Generando código, espera un momento..."),
                        ],
                      ),
                    )
                    : _generatedCode.isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CodeDisplay(code: _generatedCode),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _copyToClipboard,
                          icon: const Icon(Icons.copy),
                          label: const Text("Copiar Código"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    )
                    : const Text(
                      "Ingresa una descripción para generar código",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

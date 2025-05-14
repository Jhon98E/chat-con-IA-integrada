import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CodeDisplay extends StatelessWidget {
  final String code;
  const CodeDisplay({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            code.isEmpty
                ? const Text("Ingresa una Descripción para generar código")
                : SyntaxView(
                  code: code,
                  syntax: Syntax.DART,
                  syntaxTheme: SyntaxTheme.dracula(),
                  withZoom: true,
                  withLinesCount: true,
                ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ActionButtons extends StatefulWidget {
  final VoidCallback onDelete;

  const ActionButtons({super.key, required this.onDelete});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(
            Icons.edit,
            color: Color(0xFF343C6A),
          ),
          onPressed: () {
            // Acción para editar
          },
        ),
        const SizedBox(height: 8.0),
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Color(0xFF343C6A),
          ),
          onPressed: widget.onDelete,  // Llamamos a onDelete cuando se presiona el botón
        ),
      ],
    );
  }
}

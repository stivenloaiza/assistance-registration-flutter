import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;  // Recibimos el callback de edición

  const ActionButtons({
    super.key,
    required this.onDelete,
    required this.onEdit,  // Aceptamos el callback de edición
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),  // Ícono para editar
          onPressed: onEdit,  // Llama al callback de edición
        ),
        IconButton(
          icon: const Icon(Icons.delete),  // Ícono para eliminar
          onPressed: onDelete,  // Llama al callback de eliminación
        ),
      ],
    );
  }
}

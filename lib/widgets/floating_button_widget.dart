import 'package:asia_project/widgets/custom_modal.dart';
import 'package:asia_project/widgets/group_admin_create.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF343C6A),
      elevation: 3.0,
      shape: const CircleBorder(),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomModal(
              title: 'Nuevo Grupo',
              child: GroupForm(),
            );
          },
        );
      },
      child: const Icon(
        Icons.add,
        size: 30.0,
        color: Colors.white,
      ),
    );
  }
}

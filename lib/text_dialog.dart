import 'package:flutter/material.dart';

class TextDialog extends StatefulWidget {
  const TextDialog({super.key, required this.onPressedOnSubmt});

  final Function(String text) onPressedOnSubmt;

  @override
  State<TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<TextDialog> {
  final TextEditingController taskController =
      TextEditingController(); //instancia para crear un controlador

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add a task: "),
      content: TextField(controller: taskController),
      actions: [
        //crear cancelar y aceptar
        TextButton(
          onPressed: () => Navigator.pop(context), //cierra el pop-up
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            widget.onPressedOnSubmt(taskController.text); //llamar funcion add
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}

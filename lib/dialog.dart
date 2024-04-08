import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:test_package_call/chat_buble.dart';

class MyDialog extends StatefulWidget {
  final String? audioPath;

  const MyDialog({super.key, this.audioPath});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  void init() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Validación de venta'),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      contentPadding: EdgeInsets.all(20),
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextFormField(
                  initialValue: 'dni',
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Tipo de documento'),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: '70259377',
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Numero documento'),
                    hintText: 'Numero documento',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: 'dani',
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Ingresar comentario'),
                    hintText: 'Ingrese el texto',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: '',
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Ingresar comentario'),
                    hintText: 'Ingrese el texto',
                  ),
                ),
                if (isLoading == false)
                  WaveBubble(
                    path: widget.audioPath,
                    // index: 1,
                    isSender: true,
                    appDirectory: appDirectory,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.save),
                      label: Text('Guardar'),
                    ),
                    const SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.close),
                      label: Text('Cerrar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

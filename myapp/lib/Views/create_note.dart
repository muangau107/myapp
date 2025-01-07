import 'package:flutter/material.dart';
import 'package:myapp/JsonModels/note_model.dart';
import 'package:myapp/SQLite/sqlite.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create note"),
        actions: [
          IconButton(
            onPressed: () async {
              // Kiểm tra dữ liệu hợp lệ
              if (formKey.currentState!.validate()) {
                try {
                  await db.createNote(
                    NoteModel(
                      noteTitle: title.text,
                      noteContent: content.text,
                      createdAt: DateTime.now().toIso8601String(),
                    ),
                  );

                  // Kiểm tra context trước khi điều hướng
                  if (!context.mounted) return;
                  Navigator.of(context).pop(true);
                } catch (e) {
                  // Hiển thị lỗi nếu có
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                }
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: title,
                validator: (value) =>
                    value!.isEmpty ? "Title is required" : null,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              TextFormField(
                controller: content,
                validator: (value) =>
                    value!.isEmpty ? "Content is required" : null,
                decoration: const InputDecoration(
                  label: Text("Content"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

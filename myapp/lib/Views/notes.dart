import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/JsonModels/note_model.dart';
import 'package:myapp/SQLite/sqlite.dart';
import 'package:myapp/Views/create_note.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late DatabaseHelper handler;
  late Future<List<NoteModel>> notes;
  final db = DatabaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    notes = handler.getNotes();

    handler.initDB().then((_) {
      if (mounted) {
        setState(() {
          notes = getAllNotes();
        });
      }
    });
  }

  Future<List<NoteModel>> getAllNotes() async {
    return handler.getNotes();
  }

  // Search method here
  Future<List<NoteModel>> searchNote() async {
    return handler.searchNotes(keyword.text);
  }

  // Refresh method
  Future<void> _refresh() async {
    final refreshedNotes = await getAllNotes();
    if (mounted) {
      setState(() {
        notes = Future.value(refreshedNotes);  // Using Future.value to update the future
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateNote()))
              .then((value) {
            if (value == true && mounted) {  // Ensuring the widget is still mounted
              _refresh();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
              controller: keyword,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    notes = searchNote();
                  });
                } else {
                  setState(() {
                    notes = getAllNotes();
                  });
                }
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search"),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NoteModel>>(
              future: notes,
              builder: (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data"));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final items = snapshot.data ?? <NoteModel>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        subtitle: Text(DateFormat("yMd").format(
                            DateTime.parse(items[index].createdAt))),
                        title: Text(items[index].noteTitle),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            db.deleteNote(items[index].noteId!).then((_) {
                              if (mounted) {
                                _refresh();
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            title.text = items[index].noteTitle;
                            content.text = items[index].noteContent;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          db.updateNote(
                                              title.text,
                                              content.text,
                                              items[index].noteId).then((_) {
                                            if (context.mounted) {
                                              _refresh();
                                              Navigator.pop(context); // Using Navigator.pop inside mounted check
                                            }
                                          });
                                        },
                                        child: const Text("Update"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ],
                                title: const Text("Update note"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: title,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Title is required";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text("Title"),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: content,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Content is required";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text("Content"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

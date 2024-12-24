import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note.dart';
import 'note_provider.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'All';

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: <String>['All', 'Work', 'Personal']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newNote = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  category: _selectedCategory,
                );
                Provider.of<NoteProvider>(context, listen: false)
                    .addNote(newNote);
                _titleController.clear();
                _contentController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteProvider>(context).notes;
    final filteredNotes = _selectedCategory == 'All'
        ? notes
        : notes.where((note) => note.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
            items: <String>['All', 'Work', 'Personal']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<NoteProvider>(context, listen: false)
                          .deleteNote(note);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

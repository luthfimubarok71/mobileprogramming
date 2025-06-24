// notes_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, String>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notes');
    if (data != null) {
      final rawList = json.decode(data) as List;
      setState(() {
        _notes = rawList.map<Map<String, String>>((item) {
          return {
            'title': item['title'].toString(),
            'content': item['content'].toString(),
          };
        }).toList();
      });
    }
  }


  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes', json.encode(_notes));
  }

  void _addNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteDetailPage()),
    );
    if (result != null) {
      setState(() {
        _notes.add(result);
      });
      _saveNotes();
    }
  }

  void _editNote(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteDetailPage(note: _notes[index]),
      ),
    );
    if (result != null) {
      setState(() {
        _notes[index] = result;
      });
      _saveNotes();
    }
  }

  void _deleteNote(int index) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus catatan?'),
        content: Text('Yakin mau hapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // kirim false
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // kirim true
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() {
        _notes.removeAt(index);
      });
      _saveNotes();
    }
  }

  void _showNoteDetail(int index) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _notes[index]['title'] ?? '',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_notes[index]['content'] ?? ''),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _editNote(index);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteNote(index);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text("Hapus", style: TextStyle(color: Colors.red)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan')),
      body: _notes.isEmpty
          ? const Center(child: Text("Belum ada catatan 😢"))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(note['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      (note['content'] ?? '').length > 50
                          ? '${note['content']!.substring(0, 50)}...'
                          : (note['content'] ?? ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _showNoteDetail(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
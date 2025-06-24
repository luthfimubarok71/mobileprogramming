import 'package:flutter/material.dart';

class NoteDetailPage extends StatefulWidget {
  final Map<String, String>? note;

  const NoteDetailPage({super.key, this.note});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!['title'] ?? '';
      contentController.text = widget.note!['content'] ?? '';
    }
  }

  void _saveNote() {
    final note = {
      'title': titleController.text,
      'content': contentController.text,
    };
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Isi Catatan'),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

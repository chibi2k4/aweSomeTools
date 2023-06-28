import 'package:flutter/material.dart';

class SnippetEditorPage extends StatefulWidget {
  @override
  State<SnippetEditorPage> createState() => _SnippetEditorPageState();
}

class _SnippetEditorPageState extends State<SnippetEditorPage> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snippet Editor'),
      ),
      body: Center(
        child: TextField(
          maxLines: 128,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}

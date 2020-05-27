import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{
  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
  final Set<WordPair> _savedWordPairs = Set<WordPair>();
  static const _suggestionIncrement = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _onClickSaved)
        ],
      ),
      body: _buildSuggestions(false),
    );
  }

  void _onClickSaved() {
    log('On Click!');
    Navigator.of(context).push(
        MaterialPageRoute<void>(   // Add 20 lines from here...
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _savedWordPairs.map(
                  (WordPair pair)  => ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                ));
            final List<Widget> divided = ListTile
                .divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'),
              ),
              body: ListView(children: divided),
            );
          },
        )
    );
  }

  Widget _buildSuggestions(bool heartClickable) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          return _buildRow(index, heartClickable);
    });
  }

  Widget _buildRow(int i, heartClickable) {
    if (_suggestions.length <= i){
      _suggestions.addAll(generateWordPairs().take(_suggestionIncrement));
    }
    final suggestedWordPair = _suggestions[i];
    final wasSaved = _savedWordPairs.contains(suggestedWordPair);

    return ListTile(
        title: Text(
            suggestedWordPair.asPascalCase,
            style: _biggerFont
        ),
      trailing: Icon(
        wasSaved ? Icons.favorite : Icons.favorite_border,
        color: wasSaved ? Colors.red : null,
      ),
      onTap: heartClickable
          ? () => setState(() =>_toggleSaved(suggestedWordPair))
          : null,
    );
  }

  void _toggleSaved(WordPair wordPair){
    if (_savedWordPairs.contains(wordPair))
      _savedWordPairs.remove(wordPair);
    else
      _savedWordPairs.add(wordPair);
  }

  String _randomWordPair() => WordPair.random().asPascalCase;
}

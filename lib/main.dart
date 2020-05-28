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

class FavoritesView extends StatelessWidget {
  final Set<WordPair> _wordPairs;
  final TextStyle _font;

  FavoritesView(this._wordPairs, this._font);

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = _wordPairs.map(
            (WordPair pair)  => ListTile(
          title: Text(
            pair.asPascalCase,
            style: _font,
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
        body: WordPairListView(_wordPairs.iterator.List)(, (i, wordPair) =>
            ListTile(
              title: Text(
                  wordPair.asPascalCase,
                  style: font
              )
            ))
    );
  }

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
      body: WordPairListView(_suggestions, _buildRow),
    );
  }

  void _onClickSaved() {
    log('On Click!');
    Navigator.of(context).push(
        MaterialPageRoute<void>(   // Add 20 lines from here...
          builder: (BuildContext context)
            => FavoritesView(_savedWordPairs, _biggerFont)
        )
    );
  }

  Widget _buildRow(int i, WordPair wordPair) {
    if (_suggestions.length <= i) {
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
      onTap: () => setState(() => _toggleSaved(suggestedWordPair)),
    );
  }

  void _toggleSaved(WordPair wordPair){
    if (_savedWordPairs.contains(wordPair))
      _savedWordPairs.remove(wordPair);
    else
      _savedWordPairs.add(wordPair);
  }
}



class WordPairListView extends StatelessWidget {
  final List<WordPair> _wordPairs;
  final Widget Function(int i, WordPair wordPair) _itemBuilder;

  WordPairListView(this._wordPairs, this._itemBuilder);

  @override
  Widget build(BuildContext context) {
    return ListView.builder (
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          final wordPair = _wordPairs[index];

          return _itemBuilder(index, wordPair);
        });
  }
}


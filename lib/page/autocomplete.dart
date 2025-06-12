import 'package:flutter/material.dart';

enum ButtonState { init, loading, done }

class AutocompletePage extends StatefulWidget {
  const AutocompletePage({super.key});

  @override
  State<AutocompletePage> createState() => _AutocompletePageState();
}

class _AutocompletePageState extends State<AutocompletePage> {
  bool isAnimating = true;
  ButtonState state =ButtonState.init;

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDone = state == ButtonState.done;
    final isStreched = isAnimating || state == ButtonState.init;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pertemuan 8'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MySearch());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          width: state == ButtonState.init ? width : 70,
          onEnd: () => setState(() => isAnimating = !isAnimating),
          height: 70,
          child: isStreched ? buildButton() : buildSma11Button(isDone),
        )
      ),
    );
  }

  Widget buildButton() => OutlinedButton(
    style: OutlinedButton.styleFrom(
      shape: StadiumBorder(side: BorderSide(width: 2,color: Colors.indigo)),
    ),
    child: Text(
      'Submit',
      style: TextStyle(
        fontSize: 24,
        color: Colors.indigo,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
      ),
    ),
    onPressed: () async {
      setState(() => state = ButtonState.loading);
      await Future.delayed(Duration(seconds: 3));
      setState(() => state = ButtonState.done);
      await Future.delayed(Duration(seconds: 3));
      setState(() => state = ButtonState.init);
    },
  );

  Widget buildSma11Button(bool isDone) {
    final color = isDone ? Colors.green : Colors.indigo;

    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: 
          isDone 
          ? Icon(Icons.done, size: 52, color: Colors.white,)
          : CircularProgressIndicator(color: Colors.white,),
      ),
    );
  }
}

class MySearch extends SearchDelegate {
  List<String> searchResults = ['Flutter', 'Kotlin', 'Java', 'PHP', 'HTML'];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        }else {
          query = '';
        }
      },
      icon: Icon(Icons.clear)
    ),
  ];

  @override
  Widget buildResults(BuildContext context) => Center(
    child: Text(
      query ,
      style: TextStyle(fontSize: 64, fontWeight: FontWeight .w200),
    ),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions =
      searchResults.where((searchResults) {
        final result = searchResults.toLowerCase();
        final input = query.toLowerCase( ) ;

        return result.contains(input);
      }).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;

            showResults(context);
          },
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

class FilterSearchPage extends StatefulWidget {
  const FilterSearchPage({super.key});

  @override
  State<FilterSearchPage> createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  bool filterProyek = false;
  bool filterSkill = false;

  final List<String> allItems = [
    'Sistem Poin',
    'Absensi Karyawan',
    'Money Tracker',
    'Cloud Computing',
    'REST APIs',
    'Web Development',
    'Flutter',
    'PHP',
    'Kotlin',
    'HTML',
  ];

  List<String> filteredItems = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _applyFilter() {
    List<String> result = [];
    if (filterProyek) {
      result.addAll(['Sistem Poin', 'Absensi Karyawan', 'Money Tracker']);
    }
    if (filterSkill) {
      result.addAll(['Cloud Computing', 'REST APIs', 'Web Development']);
    }
    if (!filterProyek && !filterSkill) {
      result = allItems;
    }
    setState(() {
      filteredItems = result
          .where((item) =>
              item.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Portofolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(
                  onSelected: (value) {
                    setState(() {
                      searchQuery = value;
                      _applyFilter();
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Checkbox Proyek
          Card(
            child: InkWell(
              onTap: () {
                setState(() {
                  filterProyek = !filterProyek;
                  _applyFilter();
                });
              },
              child: SizedBox(
                height: 70,
                width: 250,
                child: Row(
                  children: [
                    Checkbox(
                      value: filterProyek,
                      onChanged: (val) {
                        setState(() {
                          filterProyek = val!;
                          _applyFilter();
                        });
                      },
                      activeColor: Colors.lightBlueAccent,
                      checkColor: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    const Image(
                      image: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/9912/9912615.png'),
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 10),
                    const Text('Proyek', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Checkbox Skills
          Card(
            child: InkWell(
              onTap: () {
                setState(() {
                  filterSkill = !filterSkill;
                  _applyFilter();
                });
              },
              child: SizedBox(
                height: 70,
                width: 250,
                child: Row(
                  children: [
                    Checkbox(
                      value: filterSkill,
                      onChanged: (val) {
                        setState(() {
                          filterSkill = val!;
                          _applyFilter();
                        });
                      },
                      activeColor: Colors.lightBlueAccent,
                      checkColor: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    const Image(
                      image: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/4727/4727496.png'),
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 10),
                    const Text('Skills', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text("Ga nemu 😢"))
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(filteredItems[index]),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final Function(String) onSelected;

  MySearchDelegate({required this.onSelected});

  List<String> searchResults = ['Flutter', 'Kotlin', 'Java', 'PHP', 'HTML'];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w200),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResults) {
      final result = searchResults.toLowerCase();
      final input = query.toLowerCase();
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
            onSelected(query);
            close(context, null);
          },
        );
      },
    );
  }
}

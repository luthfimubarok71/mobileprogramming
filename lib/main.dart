import 'package:flutter/material.dart';
import 'package:my_daily_life/page/filter_search_page.dart';
import 'package:my_daily_life/page/notes_page.dart';
import 'package:my_daily_life/page/profile_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:my_daily_life/page/login_page.dart';

void main() {
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Widget> _page = [ProfilePage(),NotesPage(),FilterSearchPage()];

  var currentPage = 0;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: _page[currentPage],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentPage,
          onTap: (i) {
            if (i == _page.length) {
              _showLogoutDialog(context);
            } else {
              setState(() => currentPage = i);
            }
          },
          items: [
            // Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person), 
              title: Text("Profile"),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.note_alt),
              title: Text("Catatan"),
              selectedColor: Colors.blue,
            ),
            // SalomonBottomBarItem(
            //   icon: Icon(Icons.check_box),
            //   title: Text("Checkbox"),
            //   selectedColor: Colors.blue,
            // ),
            // SalomonBottomBarItem(
            //   icon: Icon(Icons.map),
            //   title: Text("Maps"),
            //   selectedColor: Colors.blue,
            // ),
            SalomonBottomBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.logout),
              title: Text("Logout"),
              selectedColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Yakin mau logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
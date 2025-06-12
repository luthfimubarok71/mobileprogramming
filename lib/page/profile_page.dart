import 'dart:io';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Postingan"),
          content: const Text("Yakin mau menambahkan postingan baru?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Tambah"),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Postingan berhasil ditambahkan!"),
                    backgroundColor: Colors.blueAccent,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Background
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://as1.ftcdn.net/v2/jpg/09/27/94/24/1000_F_927942465_j6MgO2enbUJ3IHfr2hn8ZxGfY1Dshi8p.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Container(
                        alignment: const Alignment(0.0, 2.5),
                        child: CircleAvatar(
                          backgroundImage: FileImage(File('images/profil.jpg')),
                          radius: 60.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    "Luthfi Mubarok",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Ciamis, Indonesia",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Backend Developer",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat("Project", "16"),
                          _buildStat("Followers", "211k"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_on), text: "Postingan"),
                      Tab(icon: Icon(Icons.info_outline), text: "Info"),
                      Tab(icon: Icon(Icons.timeline), text: "Aktivitas"),
                    ],
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: const [
              Center(child: Text("📸 Semua Postingan")),
              Center(child: Text("ℹ️ Info Profil")),
              Center(child: Text("🕓 Aktivitas Terakhir")),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

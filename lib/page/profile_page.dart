import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<File> _photos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSavedPhotos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final ImageSource source;

    // Cek platform, pakai kamera kalau Android/iOS, galeri kalau desktop
    if (Platform.isAndroid || Platform.isIOS) {
      source = ImageSource.camera;
    } else {
      source = ImageSource.gallery;
    }

    try {
      final picked = await picker.pickImage(source: source, maxWidth: 600);
      if (picked != null) {
        final directory = await getApplicationDocumentsDirectory();
        final name = DateTime.now().millisecondsSinceEpoch.toString();
        final saved = await File(picked.path).copy('${directory.path}/$name.jpg');
        setState(() => _photos.add(saved));
        final prefs = await SharedPreferences.getInstance();
        final currentPaths = prefs.getStringList('saved_photos') ?? [];
        currentPaths.add(saved.path);
        await prefs.setStringList('saved_photos', currentPaths);
      }
    } catch (e) {
      // Optional: tampilin error kalau gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal ambil gambar: $e')),
      );
    }
  }

  Future<void> _loadSavedPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList('saved_photos') ?? [];

    setState(() {
      _photos.clear();
      _photos.addAll(paths.map((p) => File(p)));
    });
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (ctx, i) => GestureDetector(
        onLongPress: () => _showDeleteDialog(i),
        child: Image.file(_photos[i], fit: BoxFit.cover),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Foto"),
        content: const Text("Yakin mau menghapus foto ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              _deletePhoto(index);
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePhoto(int index) async {
    try {
      await _photos[index].delete(); // Hapus file fisik
    } catch (e) {
      debugPrint("Gagal hapus file: $e");
    }

    setState(() {
      _photos.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_photos', _photos.map((f) => f.path).toList());
  }

  Widget _buildActivityChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, 2),
              FlSpot(2, 3),
              FlSpot(3, 1),
              FlSpot(4, 4),
              FlSpot(5, 3),
              FlSpot(6, 5),
              FlSpot(7, 2),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            dotData: FlDotData(show: true),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, inner) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://as1.ftcdn.net/v2/jpg/09/27/94/24/1000_F_927942465_j6MgO2enbUJ3IHfr2hn8ZxGfY1Dshi8p.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 200,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(
                        backgroundImage: FileImage(File('images/profil.jpg')),
                      radius: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Luthfi Mubarok", style: TextStyle(fontSize: 22)),
                const Text("Ciamis, Indonesia", style: TextStyle(fontSize: 16)),
                const Text("Backend Developer", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 10),
                TabBar(
                  controller: _tabController, // <-- Tambahin ini
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
          children: [
            _photos.isEmpty
              ? const Center(child: Text('Belum ada postingan 😢'))
              : _buildPhotoGrid(),
            const Center(child: Text("ℹ️ Info Profil")),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildActivityChart(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

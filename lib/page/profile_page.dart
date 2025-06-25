// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

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
    _getCurrentLocation();
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
    final dummyData = <String, int>{
      'Sen': 2,
      'Sel': 1,
      'Rab': 3,
      'Kam': 0,
      'Jum': 4,
      'Sab': 2,
      'Min': 1,
    };

    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final spots = List.generate(
      days.length,
      (i) => FlSpot(i.toDouble(), dummyData[days[i]]!.toDouble()),
    );

    return LineChart(
      LineChartData(
        minY: 0,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                int idx = value.toInt();
                return Text(
                  days[idx],
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) => Text(value.toInt().toString()),
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            // ignore: deprecated_member_use
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
            dotData: FlDotData(show: true),
          )
        ],
      ),
    );
  }

  LatLng? _userLocation;
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        return;
      }
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    if (!mounted) return; // ⛑️ Tambahan penting biar gak crash

    setState(() {
      _userLocation = LatLng(pos.latitude, pos.longitude);
    });
  }

  Widget _buildMap() {
    if (_userLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      options: MapOptions(
        // ignore: deprecated_member_use
        center: _userLocation,
        // ignore: deprecated_member_use
        zoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: _userLocation!,
              child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
            ),
          ],
        ),
      ],
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
                        backgroundImage: AssetImage('assets/images/profil.jpg'),
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
            _userLocation == null
              ? const Center(child: Text("Menunggu lokasi..."))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 300,
                      child: _buildMap(),
                    ),
                  ),
                ),
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

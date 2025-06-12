import 'package:flutter/material.dart';
import 'package:mobileprogrammingp9/page/list_page.dart';

class PertemuanPage extends StatelessWidget {
  final Pertemuan pertemuan;

  const PertemuanPage({super.key, required this.pertemuan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pertemuan.title)),
      body: Column(
        children: [
          Text(
            pertemuan.subtitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
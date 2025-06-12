import 'package:flutter/material.dart';

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  State<CheckboxPage> createState() => _CheckboxPage();
}

class _CheckboxPage extends State<CheckboxPage> {
  int currentPage = 0;

  bool Proyek =  false;
  bool Skills = false;

  List menu = [];

  void updateMenu() {
    menu.clear();
    if (Proyek == true) {
      menu.addAll(['Sistem Poin, Absensi Karyawan, Money Tracker']);
    }
    if (Skills == true) {
      menu.addAll(['Cloud Computing, REST APIs , Web Development']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Portofolio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            // Menu 1
            SizedBox(height: 20),
            Card(
              child: SizedBox(
                height: 70,
                width: 250,
                child: Row(
                  children: [
                    Checkbox(
                      value: Proyek,
                      onChanged: (value) {
                        setState(() { 
                          Proyek = !Proyek; 
                          updateMenu(); 
                        });
                      },
                      activeColor: Colors.lightBlueAccent,
                      checkColor: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Image(image: NetworkImage('https://cdn-icons-png.flaticon.com/512/9912/9912615.png')),
                    SizedBox(width: 10),
                    Text('Proyek', style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
            ),

            // Menu 2
            SizedBox(height: 20),
            Card(
              child: SizedBox(
                height: 70,
                width: 250,
                child: Row(
                  children: [
                    Checkbox(
                      value: Skills,
                      onChanged: (value) {
                        setState(() { 
                          Skills = !Skills; 
                          updateMenu();
                        });
                      },
                      activeColor: Colors.lightBlueAccent, 
                      checkColor: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Image(image: NetworkImage('https://cdn-icons-png.flaticon.com/512/4727/4727496.png')),
                    SizedBox(width: 15),
                    Text('Skills', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Proyek || Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            
            SizedBox(height: 15),
            Wrap(children: [for (var item in menu) Text('$item ,')]),
          ],
        ),
      ),
    );
  }
}
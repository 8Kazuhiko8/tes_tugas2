import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'daftar_situs_rekomendasi.dart';
import 'stopwatch.dart';
import 'favorit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  List<Map<String, String>> favorites = [];

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Utama'),
        backgroundColor: Colors.brown[200],
      ),
      body: Container(
        color: Colors.lightBlue[100],
        child: Center(
          child: _selectedIndex == 0 ? _buildMainMenu() : HelpScreen(logoutCallback: _logout),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Bantuan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.brown[200],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
      ),
    );
  }

  Widget _buildMainMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildMenuButton(
          'Daftar Anggota',
          Icons.people,
              () => _showMembers(context),
        ),
        SizedBox(height: 20),
        _buildMenuButton(
          'Aplikasi Stopwatch',
          Icons.timer,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StopwatchScreen()),
            );
          },
        ),
        SizedBox(height: 20),
        _buildMenuButton(
          'Daftar Situs Rekomendasi',
          Icons.web,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DaftarSitusRekomendasi(favorites: favorites)),
            );
          },
        ),
        SizedBox(height: 20),
        _buildMenuButton(
          'Favorit',
          Icons.favorite,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Favorit(favorites: favorites)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 30),
      label: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  void _showMembers(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Daftar Anggota"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Dimas Rahmadhan (124220024)"),
                Text("Muhammad Salman Mahdi (124220014)"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class HelpScreen extends StatelessWidget {
  final VoidCallback logoutCallback;

  HelpScreen({required this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(); // Kembali ke menu utama
        return false; // Mencegah kembali ke login
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bantuan'),
          backgroundColor: Colors.brown[200],
        ),
        body: Container(
          color: Colors.lightBlue[100],
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Cara Penggunaan Aplikasi",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildHelpText("1. Tekan tombol 'Register' di halaman login untuk mendaftar."),
                _buildHelpText("2. Login dengan email dan password setelah mendaftar."),
                _buildHelpText("3. Gunakan menu 'Daftar Anggota' untuk melihat anggota."),
                _buildHelpText("4. Gunakan menu 'Stopwatch' untuk menjalankan stopwatch."),
                _buildHelpText("5. Gunakan menu 'Daftar Situs Rekomendasi' untuk melihat rekomendasi."),
                _buildHelpText("6. Gunakan menu 'Favorit' untuk melihat situs yang ditandai."),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: logoutCallback,
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}

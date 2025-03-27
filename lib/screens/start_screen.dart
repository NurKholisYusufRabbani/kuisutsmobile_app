import 'package:flutter/material.dart';

// StartScreen adalah widget stateless yang ditampilkan saat aplikasi pertama kali dijalankan.
// Widget ini menampilkan pesan selamat datang dan tombol untuk memulai kuis.
class StartScreen extends StatelessWidget {
  // Callback yang akan dipanggil saat tombol "Mulai Quiz" ditekan.
  final VoidCallback startQuiz;

  // Constructor dengan parameter required untuk menerima callback startQuiz.
  StartScreen({required this.startQuiz});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Column digunakan untuk menyusun widget secara vertikal.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Memusatkan semua widget secara vertikal.
        children: [
          // Menampilkan gambar dari file assets dengan ukuran lebar 200.
          Image.asset('assets/cartoon_quiz.png', width: 200),
          SizedBox(height: 20), // Jarak antara gambar dan teks.
          // Teks "Selamat Datang!" dengan gaya tulisan besar, bold, dan berwarna cokelat.
          Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          SizedBox(height: 10), // Jarak antara teks utama dan teks deskripsi.
          // Teks deskripsi untuk memberikan informasi tambahan kepada pengguna.
          Text(
            'Tes pengetahuanmu dengan quiz seru ini!',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          SizedBox(height: 20), // Jarak antara teks deskripsi dan tombol.
          // Tombol ElevatedButton untuk memulai kuis.
          ElevatedButton(
            onPressed: startQuiz, // Memanggil fungsi startQuiz saat tombol ditekan.
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber, // Warna latar tombol.
              foregroundColor: Colors.black, // Warna teks pada tombol.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Membuat sudut tombol melengkung.
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Padding tombol.
            ),
            child: Text(
              'Mulai Quiz', // Teks yang ditampilkan pada tombol.
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

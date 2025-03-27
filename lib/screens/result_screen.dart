import 'package:flutter/material.dart';

// Widget ResultScreen adalah layar hasil kuis yang menampilkan skor pengguna
// serta menyediakan tombol untuk mengulangi kuis.
class ResultScreen extends StatelessWidget {
  // Skor pengguna dari total pertanyaan.
  final int score;

  // Total jumlah pertanyaan dalam kuis.
  final int total;

  // Callback function untuk mereset kuis ketika tombol "Coba Lagi" ditekan.
  final VoidCallback resetQuiz;

  // Constructor menerima skor, total, dan fungsi reset sebagai parameter.
  ResultScreen({
    required this.score,
    required this.total,
    required this.resetQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // Elemen-elemen ditata di tengah layar secara vertikal.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gambar trofi untuk menandai layar hasil.
          Image.asset(
            'assets/trophy.png',
            width: 150, // Ukuran lebar gambar.
          ),
          SizedBox(height: 20), // Jarak antara gambar dan teks skor.
          // Teks untuk menampilkan skor pengguna.
          Text(
            'Skor Anda: $score dari $total',
            style: TextStyle(
              fontSize: 22, // Ukuran teks.
              fontWeight: FontWeight.bold, // Membuat teks tebal.
              color: Colors.brown, // Warna teks.
            ),
          ),
          SizedBox(height: 20), // Jarak antara teks skor dan tombol.
          // Tombol untuk mereset kuis.
          ElevatedButton(
            onPressed: resetQuiz, // Memanggil fungsi resetQuiz saat tombol ditekan.
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber, // Warna latar tombol.
              foregroundColor: Colors.black54, // Warna teks tombol.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Sudut melengkung pada tombol.
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 40, // Padding horizontal.
                vertical: 15, // Padding vertikal.
              ),
            ),
            // Teks pada tombol.
            child: Text(
              'Coba Lagi',
              style: TextStyle(
                fontSize: 18, // Ukuran teks tombol.
                fontWeight: FontWeight.bold, // Membuat teks tombol tebal.
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

// Widget QuizScreen adalah layar utama untuk menampilkan pertanyaan kuis dan opsi jawaban.
// Widget ini adalah StatelessWidget karena tidak memiliki status internal,
// dan semua data diterima dari parameter.
class QuizScreen extends StatelessWidget {
  // Daftar pertanyaan yang akan ditampilkan.
  final List<dynamic> questions;

  // Indeks pertanyaan saat ini yang sedang ditampilkan.
  final int currentIndex;

  // Callback function yang akan dipanggil ketika pengguna memilih jawaban.
  final Function(String) answerQuestion;

  // Constructor untuk menerima data yang dibutuhkan, seperti daftar pertanyaan,
  // indeks saat ini, dan fungsi untuk menangani jawaban.
  QuizScreen({
    required this.questions,
    required this.currentIndex,
    required this.answerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Isi disusun di tengah layar secara vertikal.
      children: [
        // Menampilkan pertanyaan di bagian atas layar.
        Padding(
          padding: EdgeInsets.all(16.0), // Menambahkan padding di sekitar teks pertanyaan.
          child: Text(
            // Pertanyaan diambil berdasarkan indeks saat ini.
            questions[currentIndex]['question'],
            style: TextStyle(
              fontSize: 20, // Ukuran teks pertanyaan.
              fontWeight: FontWeight.bold, // Membuat teks menjadi tebal.
              color: Colors.brown, // Warna teks pertanyaan.
            ),
            textAlign: TextAlign.center, // Teks ditampilkan di tengah secara horizontal.
          ),
        ),
        // Menampilkan daftar opsi jawaban untuk pertanyaan saat ini.
        // Menggunakan map untuk memproses setiap opsi menjadi widget ElevatedButton.
        ...questions[currentIndex]['options'].map<Widget>((option) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20), // Margin antar tombol.
            width: double.infinity, // Lebar tombol menyesuaikan dengan layar.
            child: ElevatedButton(
              // Memanggil fungsi answerQuestion dengan opsi yang dipilih pengguna.
              onPressed: () => answerQuestion(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Warna latar tombol.
                foregroundColor: Colors.black, // Warna teks tombol.
                shadowColor: Colors.amber, // Warna bayangan tombol.
                elevation: 5, // Efek ketinggian tombol untuk memberikan bayangan.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Sudut tombol melengkung.
                ),
                padding: EdgeInsets.symmetric(vertical: 15), // Padding vertikal tombol.
              ),
              child: Text(
                option, // Menampilkan teks opsi pada tombol.
                style: TextStyle(fontSize: 16), // Ukuran teks opsi.
              ),
            ),
          );
        }).toList(), // Mengonversi hasil map menjadi daftar widget.
      ],
    );
  }
}

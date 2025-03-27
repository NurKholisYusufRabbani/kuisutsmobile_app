import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

// Abstraction: QuizBase adalah kelas abstrak yang mendefinisikan kerangka fungsi utama untuk kelas quiz.
abstract class QuizBase {
  void loadQuestions(); // Untuk memuat daftar pertanyaan dari sumber data
  void answerQuestion(String selectedAnswer); // Untuk memproses jawaban pengguna
  void resetQuiz(); // Untuk mereset state quiz
}

// Entry point aplikasi
void main() {
  runApp(QuizApp());
}

// Widget utama aplikasi
class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() => _QuizAppState();
}

// Inheritance: _QuizAppState mewarisi dan mengimplementasikan QuizBase, menerapkan logika inti quiz.
class _QuizAppState extends State<QuizApp> implements QuizBase {
  // Enkapsulasi: Variabel-variabel di bawah ini adalah private karena diawali dengan underscore (_),
  // memastikan bahwa mereka hanya dapat diakses oleh kelas ini.
  List<dynamic> _questions = []; // Menyimpan daftar pertanyaan
  int _currentQuestionIndex = 0; // Indeks pertanyaan saat ini
  int _score = 0; // Skor pengguna
  bool _quizCompleted = false; // Status apakah quiz selesai
  bool _quizStarted = false; // Status apakah quiz sudah dimulai

  @override
  void initState() {
    super.initState();
    loadQuestions(); // Memuat pertanyaan saat aplikasi pertama kali dijalankan
  }

  // Polymorphism: Implementasi fungsi loadQuestions dari QuizBase
  @override
  Future<void> loadQuestions() async {
    // Memuat file JSON berisi daftar pertanyaan
    String jsonString = await rootBundle.loadString('assets/questions.json');
    final jsonResponse = json.decode(jsonString);

    // Mengacak daftar pertanyaan agar urutannya tidak sama setiap kali quiz dimainkan
    List<dynamic> allQuestions = jsonResponse['questions'];
    allQuestions.shuffle(Random());

    // Enkapsulasi: Variabel _questions hanya dapat dimodifikasi melalui fungsi ini.
    setState(() {
      _questions = allQuestions.take(10).toList(); // Mengambil 10 pertanyaan acak
    });
  }

  // Polymorphism: Implementasi fungsi answerQuestion dari QuizBase
  @override
  void answerQuestion(String selectedAnswer) {
    // Mengecek apakah jawaban pengguna benar
    if (selectedAnswer == _questions[_currentQuestionIndex]['answer']) {
      _score++; // Tambahkan skor jika jawaban benar
    }

    // Pindah ke pertanyaan berikutnya atau menandai quiz selesai
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  // Polymorphism: Implementasi fungsi resetQuiz dari QuizBase
  @override
  void resetQuiz() {
    // Mengatur ulang state quiz untuk memulai ulang
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _quizStarted = false;
    });

    loadQuestions(); // Memuat ulang daftar pertanyaan
  }

  // Fungsi untuk memulai quiz
  void _startQuiz() {
    setState(() {
      _quizStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.brown),
      home: Scaffold(
        backgroundColor: Color(0xFFEEE8AA), // Warna latar belakang aplikasi
        appBar: AppBar(
          title: Text('Kuis Pengetahuan Umum!'), // Judul aplikasi
          backgroundColor: Colors.orangeAccent, // Warna AppBar
        ),
        // Mengatur tampilan layar berdasarkan status quiz
        body: _questions.isEmpty
            ? Center(child: CircularProgressIndicator()) // Tampilkan loading jika pertanyaan belum dimuat
            : !_quizStarted
            ? _buildStartScreen() // Layar awal sebelum quiz dimulai
            : _quizCompleted
            ? _buildResultScreen() // Layar hasil setelah quiz selesai
            : _buildQuizScreen(), // Layar utama quiz
      ),
    );
  }

  // Tampilan layar awal sebelum quiz dimulai
  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/cartoon_quiz.png', width: 200), // Gambar ilustrasi quiz
          SizedBox(height: 20), // Spasi antar elemen
          Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tes pengetahuanmu dengan quiz seru ini!',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          SizedBox(height: 20),
          // Tombol untuk memulai quiz
          ElevatedButton(
            onPressed: _startQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text(
              'Mulai Quiz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan layar utama quiz
  Widget _buildQuizScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            _questions[_currentQuestionIndex]['question'], // Pertanyaan saat ini
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Menampilkan pilihan jawaban sebagai tombol
        ..._questions[_currentQuestionIndex]['options'].map<Widget>((option) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => answerQuestion(option), // Fungsi ketika tombol diklik
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shadowColor: Colors.amber,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(option, style: TextStyle(fontSize: 16)),
            ),
          );
        }).toList(),
      ],
    );
  }

  // Tampilan layar hasil setelah quiz selesai
  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/trophy.png', width: 150), // Gambar piala
          SizedBox(height: 20),
          Text(
            'Skor Anda: $_score dari ${_questions.length}', // Menampilkan skor akhir
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          SizedBox(height: 20),
          // Tombol untuk memulai ulang quiz
          ElevatedButton(
            onPressed: resetQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text(
              'Coba Lagi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

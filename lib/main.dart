import 'package:flutter/material.dart';
import 'screens/start_screen.dart'; // Layar untuk memulai kuis
import 'screens/quiz_screen.dart'; // Layar untuk menjawab kuis
import 'screens/result_screen.dart'; // Layar untuk hasil akhir kuis
import 'models/quiz_base.dart'; // Interface yang digunakan untuk kontrak fungsi
import 'dart:convert'; // Untuk JSON decoding
import 'package:flutter/services.dart' show rootBundle; // Untuk membaca file dari folder assets
import 'dart:math'; // Untuk fungsi randomisasi

// Fungsi utama aplikasi Flutter
void main() {
  runApp(QuizApp()); // Menjalankan aplikasi QuizApp
}

// Widget utama aplikasi
class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() => _QuizAppState();
}

// State untuk aplikasi kuis
class _QuizAppState extends State<QuizApp> implements QuizBase {
  // Properti _questions bersifat private (ditandai dengan "_").
  // Properti ini hanya dapat diakses dan dimodifikasi di dalam kelas _QuizAppState,
  // sesuai dengan prinsip encapsulation.
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  bool _quizStarted = false;

  @override
  void initState() {
    super.initState();
    loadQuestions(); // Memuat pertanyaan saat aplikasi dimulai
  }

  // Encapsulation: Fungsi ini digunakan untuk memuat pertanyaan.
  // Fungsi ini bersifat public (dari interface QuizBase) tetapi tetap mengatur logika internal,
  // sehingga detail implementasinya tersembunyi dari pengguna luar.
  @override
  Future<void> loadQuestions() async {
    String jsonString = await rootBundle.loadString('assets/questions.json');
    final jsonResponse = json.decode(jsonString);
    List<dynamic> allQuestions = jsonResponse['questions'];
    allQuestions.shuffle(Random());
    setState(() {
      _questions = allQuestions.take(10).toList();
    });
  }

  // Encapsulation: Mengatur logika menjawab pertanyaan di satu fungsi.
  // Detail seperti pengecekan jawaban dan pengaturan indeks hanya terjadi di dalam fungsi ini.
  @override
  void answerQuestion(String selectedAnswer) {
    if (selectedAnswer == _questions[_currentQuestionIndex]['answer']) {
      _score++;
    }
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

  // Encapsulation: Fungsi ini mereset seluruh properti ke keadaan awal.
  // Detail implementasi disembunyikan dari kelas lain.
  @override
  void resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _quizStarted = false;
    });
    loadQuestions(); // Memuat ulang pertanyaan
  }

  // Fungsi private untuk memulai kuis.
  void _startQuiz() {
    setState(() {
      _quizStarted = true;
    });
  }

  // Fungsi untuk membangun UI aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.brown),
      home: Scaffold(
        backgroundColor: Color(0xFFEEE8AA),
        appBar: AppBar(
          title: Text('Kuis Pengetahuan Umum!'),
          backgroundColor: Colors.orangeAccent,
        ),
        body: _questions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : !_quizStarted
            ? StartScreen(startQuiz: _startQuiz)
            : _quizCompleted
            ? ResultScreen(
          score: _score,
          total: _questions.length,
          resetQuiz: resetQuiz,
        )
            : QuizScreen(
          questions: _questions,
          currentIndex: _currentQuestionIndex,
          answerQuestion: answerQuestion,
        ),
      ),
    );
  }
}

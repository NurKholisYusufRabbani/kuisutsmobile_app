import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  bool _quizStarted = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    String jsonString = await rootBundle.loadString('assets/questions.json');
    final jsonResponse = json.decode(jsonString);

    List<dynamic> allQuestions = jsonResponse['questions'];
    allQuestions.shuffle(Random()); // Acak soal

    setState(() {
      _questions = allQuestions.take(10).toList(); // Ambil 10 soal
    });
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
    });
  }

  void _answerQuestion(String selectedAnswer) {
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

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _quizStarted = false;
    });

    _loadQuestions();
  }

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
            ? _buildStartScreen()
            : _quizCompleted
            ? _buildResultScreen()
            : _buildQuizScreen(),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/cartoon_quiz.png', width: 200),
          SizedBox(height: 20),
          Text('Selamat Datang!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown)),
          SizedBox(height: 10),
          Text('Tes pengetahuanmu dengan quiz seru ini!', style: TextStyle(fontSize: 16, color: Colors.black54)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text('Mulai Quiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            _questions[_currentQuestionIndex]['question'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
            textAlign: TextAlign.center,
          ),
        ),
        ..._questions[_currentQuestionIndex]['options'].map<Widget>((option) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _answerQuestion(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shadowColor: Colors.amber,
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(option, style: TextStyle(fontSize: 16)),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/trophy.png', width: 150),
          SizedBox(height: 20),
          Text(
            'Skor Anda: $_score dari ${_questions.length}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black54,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text('Coba Lagi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

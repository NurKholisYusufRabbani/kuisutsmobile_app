// Kelas abstrak QuizBase digunakan sebagai kontrak untuk memastikan semua kelas turunan
// yang mengimplementasikannya memiliki fungsi-fungsi berikut: loadQuestions, answerQuestion, dan resetQuiz.
abstract class QuizBase {
  // Fungsi abstrak untuk memuat pertanyaan dari sumber tertentu (misalnya, file JSON).
  void loadQuestions();

  // Fungsi abstrak untuk menangani jawaban dari pengguna.
  // Parameter:
  // - selectedAnswer: Jawaban yang dipilih oleh pengguna.
  void answerQuestion(String selectedAnswer);

  // Fungsi abstrak untuk mereset kuis ke kondisi awal.
  void resetQuiz();
}

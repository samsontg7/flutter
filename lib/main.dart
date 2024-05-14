import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ss.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Learn Flutter the Fun Way',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
                child: Text('Start Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  List<String> questions = [
    'What are the main building blocks of Flutter UIs?',
    'How are Flutter UIs built?',
  ];
  List<List<String>> choices = [
    ['Functions', 'components', 'Blocks', 'Widgets'],
    [
      ' By combining widgets in a visual editor',
      'By using XCode for iOS and Android Studio for Android',
      'By Combining widgets in code',
      'By defining widgets in config files'
    ],
  ];
  List<int> selectedAnswers = List.filled(2, -1);

  void checkAnswer(int index) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = index;
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void goBack() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  void showResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          questions: questions,
          choices: choices,
          selectedAnswers: selectedAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Quiz'),
      ),
      backgroundColor: Color.fromARGB(255, 70, 3, 225),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 53, 4, 21)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              questions[currentQuestionIndex],
              style: const TextStyle(
                  fontSize: 24, color: Color.fromARGB(255, 137, 60, 232)),
              textAlign: TextAlign.center,
            ),
          ),
          for (int i = 0; i < choices[currentQuestionIndex].length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => checkAnswer(i),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: i == selectedAnswers[currentQuestionIndex]
                        ? Colors.blue
                        : Color.fromARGB(255, 31, 10, 101),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    choices[currentQuestionIndex][i],
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: goBack,
                child: const Text('Back'),
              ),
              const SizedBox(width: 10),
              if (currentQuestionIndex == questions.length - 1)
                ElevatedButton(
                  onPressed: showResult,
                  child: const Text('Submit'),
                )
              else
                ElevatedButton(
                  onPressed: nextQuestion,
                  child: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final List<String> questions;
  final List<List<String>> choices;
  final List<int> selectedAnswers;

  ResultPage({
    required this.questions,
    required this.choices,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    int correctAnswers = 0;
    List<List<int>> correctIndices = [
      [3],
      [2],
      [0],
    ]; // Correct indices for the choices of each question

    List<Widget> scoreWidgets = [];

    for (int i = 0; i < questions.length; i++) {
      bool isCorrect = true;
      String question = questions[i];
      List<String> answerChoices = choices[i];
      int selectedAnswer = selectedAnswers[i];

      for (int j = 0; j < correctIndices[i].length; j++) {
        if (selectedAnswer != correctIndices[i][j]) {
          isCorrect = false;
          break;
        }
      }
      if (isCorrect) {
        correctAnswers++;
      }

      scoreWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${i + 1}:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              question,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Your Answer: ${answerChoices[selectedAnswer]}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              'Correct Answer: ${answerChoices[correctIndices[i][0]]}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
      ),
      backgroundColor: Color.fromARGB(255, 70, 3, 225),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Result',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Questions: ${questions.length}',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Correct Answers: $correctAnswers',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: scoreWidgets,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the quiz page
              },
              child: const Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

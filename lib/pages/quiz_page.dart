import 'package:flutter/material.dart';

import 'package:quizapp/utils/question.dart';
import 'package:quizapp/utils/quiz.dart';
import 'package:quizapp/ui/answer_button.dart';
import 'package:quizapp/ui/question_text.dart';
import 'package:quizapp/ui/overlay_iscorrect.dart';
import 'package:quizapp/pages/score_page.dart';

import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Ellon Musk is human", false),
    new Question("Pizza is healthy", false),
    new Question("Flutter is awesome", true)
  ]);

  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
    super.initState();
  }

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
          //This is a main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false))
          ],
        ),
        overlayShouldBeVisible == true
            ? new CorrectWrongOverlay(isCorrect, () {
                if (quiz.length == questionNumber) {
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ScorePage(quiz.score, quiz.length)),
                      (Route route) => route == null);
                  return;
                }

                currentQuestion = quiz.nextQuestion;
                this.setState(() {
                  overlayShouldBeVisible = false;
                  questionText = currentQuestion.question;
                  questionNumber = quiz.questionNumber;
                });
              })
            : new Container(),
      ],
    );
  }
}

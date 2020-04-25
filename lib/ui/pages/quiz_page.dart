import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:quizzmaster/models/category.dart';
import 'package:quizzmaster/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quizzmaster/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;

  const QuizPage({Key key, @required this.questions, this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var interstitialAd;

  InterstitialAd myInterstitial() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      // adUnitId: Common().interstitialUnitId,
      // listener: (MobileAdEvent event) {
      //   if (event == MobileAdEvent.failedToLoad) {
      //     interstitialAd..load();
      //   } else if (event == MobileAdEvent.closed) {
      //     // interstitialAd = myInterstitial()..load();
      //   }
      // },
    );
  }

  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return Padding(
      padding: EdgeInsets.only(
        // bottom: Common().getSmartBannerHeight(mediaQuery),
        bottom: 0.0,
      ),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text(
              widget.category.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            elevation: 0,
          ),
          body: Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: Text("${_currentIndex + 1}"),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: Text(
                            HtmlUnescape().convert(
                              widget.questions[_currentIndex].question,
                            ),
                            softWrap: true,
                            style: _questionStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ...options.map(
                            (option) => RadioListTile(
                              activeColor: Theme.of(context).primaryColor,
                              title: Text(HtmlUnescape().convert("$option")),
                              groupValue: _answers[_currentIndex],
                              value: option,
                              onChanged: (value) {
                                setState(() {
                                  _answers[_currentIndex] = option;
                                  Timer(Duration(milliseconds: 500), () async {
                                    _nextSubmit();
                                  });
                                  // Timer(Duration(seconds: 1), () async {
                                  //   if (_currentIndex <
                                  //       (widget.questions.length - 1)) {
                                  //     _currentIndex++;
                                  //   }
                                  // });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     alignment: Alignment.bottomCenter,
                    //     child: RaisedButton(
                    //       child: Text(
                    //         _currentIndex == (widget.questions.length - 1)
                    //             ? "Submit"
                    //             : "Next",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       onPressed: _nextSubmit,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAdmobInterstitialAd() {
    interstitialAd = myInterstitial()
      ..load()
      ..show();
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("You must select an answer to continue."),
        ),
      );
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // showAdmobInterstitialAd();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => quizFinishedPage(
            questions: widget.questions,
            answers: _answers,
          ),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    return Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        animationType: AnimationType.fromTop,
      ),
      type: AlertType.warning,
      title: "Warning!",
      desc:
          "Are you sure you want to quit the quiz? \r\n\r\n All your progress will be lost.",
      buttons: [
        DialogButton(
          color: Colors.black87,
          child: Text(
            "No",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.pop(
              context,
              false,
            );
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.black87,
          child: Text(
            "Yes",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.pop(
              context,
              true,
            );
          },
          width: 120,
        ),
      ],
    ).show();
  }
}

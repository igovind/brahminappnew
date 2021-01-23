/*
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';

class ScrachCard extends StatefulWidget {
  @override
  _ScrachCardState createState() => _ScrachCardState();
}

class _ScrachCardState extends State<ScrachCard> {
  ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ConfettiController(
      duration: new Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Scratcher(
          brushSize: 50,
          threshold: 75,
          color: Colors.red,
          image: Image.asset(
            "images/outerimage.png",
            fit: BoxFit.fill,
          ),
          onChange: (value) => print("Scratch progress: $value%"),
          onThreshold: () => _controller.play(),
          child: Container(
            height: 300,
            width: 300,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "images/newimage.png",
                  fit: BoxFit.contain,
                  width: 150,
                  height: 150,
                ),
                Column(
                  children: [
                    ConfettiWidget(
                      blastDirectionality: BlastDirectionality.explosive,
                      confettiController: _controller,
                      particleDrag: 0.05,
                      emissionFrequency: 0.05,
                      numberOfParticles: 100,
                      gravity: 0.05,
                      shouldLoop: false,
                      colors: [
                        Colors.green,
                        Colors.red,
                        Colors.yellow,
                        Colors.blue,
                      ],
                    ),
                    Text(
                      "You won",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "1 Lakh!",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CardSc(),
    );
  }
}

// ignore: must_be_immutable
class CardSc extends StatelessWidget {
  double _opacity = 0.0;

  Future<void> scratchCardDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'You\'ve won a scratch card',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
            return Scratcher(
              accuracy: ScratchAccuracy.low,
              threshold: 25,
              brushSize: 50,
              onThreshold: () {
                setState(() {
                  _opacity = 1;
                });
              },
              image: Image.asset("images/diamond_bw.png"),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 250),
                opacity: _opacity,
                child: Container(
                  height: 300,
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    "200\$",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.blue),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),
        color: Colors.blue,
        child: Text(
          "Get A ScratchCard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        onPressed: () => scratchCardDialog(context),
      ),
    );
  }
}

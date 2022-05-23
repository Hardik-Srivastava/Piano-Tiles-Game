// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors, prefer_const_constructors
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pianotiles/model/note_model.dart';
import 'package:pianotiles/provider/note_state.dart';
import 'package:pianotiles/provider/song_provider.dart';
import 'package:pianotiles/screen/widgets/line_divider.dart';
import 'package:pianotiles/screen/widgets/line_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<NoteModel> notes = mission1();
  late AnimationController _animationController;
  int currentNoteIndex = 0;
  int points = 0;
  bool isPlaying = true;
  bool hasGameStarted = false;
  final player = AudioCache();
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (notes[currentNoteIndex].noteState != NoteState.TappedState) {
          setState(() {
            isPlaying = false;
          });
          _animationController.reverse().then((value) => _showFinishDialog());
        } else if (currentNoteIndex == (notes.length - 5)) {
          //  Song finished
        } else {
          setState(() {
            currentNoteIndex++;
          });
          _animationController.forward(from: 0);
        }
      }
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              height: double.infinity,
              child: Image.asset("assets/background.gif", fit: BoxFit.cover),
            ),
            Row(
              children: [
                drawLineWidget(0),
                LineDivider(),
                drawLineWidget(1),
                LineDivider(),
                drawLineWidget(2),
                LineDivider(),
                drawLineWidget(3),
              ],
            ),
            _drawPoints(),
          ],
        ),
      ),
    );
  }

  Widget drawLineWidget(int lineNumber) {
    return Expanded(
        child: LineWidget(
      lineNumber: lineNumber,
      currentNotes: notes.sublist(currentNoteIndex, currentNoteIndex + 4),
      animation: _animationController,
      onTileTap: (NoteModel note) {
        bool areAllPreviousTapped = notes
            .sublist(0, note.ordernumber)
            .every((note) => note.noteState == NoteState.TappedState);
        if (areAllPreviousTapped) {
          if (!hasGameStarted) {
            setState(() {
              hasGameStarted = true;
            });
            _animationController.forward();
          }
          _noteplay(note);
          setState(() {
            note.noteState = NoteState.TappedState;
            ++points;
          });
        }
      },
    ));
  }

  void restart() {
    setState(() {
      hasGameStarted = false;
      isPlaying = true;
      notes = mission1();
      points = 0;
      currentNoteIndex = 0;
    });
    _animationController.reset();
  }

  void _showFinishDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text("Score: $points"), actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Restart"),
            )
          ]);
        }).then((value) => restart());
  }

  _drawPoints() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Text(
          "$points",
          style: TextStyle(color: Colors.red, fontSize: 60),
        ),
      ),
    );
  }

  void _noteplay(NoteModel note) {
    switch (note.line) {
      case 0:
        player.play('a.wav');
        return;
      case 1:
        player.play('c.wav');
        return;
      case 2:
        player.play('e.wav');
        return;
      case 3:
        player.play('f.wav');
        return;
    }
  }
}

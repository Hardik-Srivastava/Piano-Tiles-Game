import 'package:flutter/material.dart';
import 'package:pianotiles/provider/note_state.dart';

// ignore: use_key_in_widget_constructors
class LineTiles extends StatelessWidget {
  final NoteState noteState;
  final double height;
  final VoidCallback onTap;
  final int? index;

  const LineTiles({Key? key, required this.noteState, required this.height, required this.onTap,  this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTapDown: (_){
        onTap();
      },
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Container(
            color:color,
          ),
        ),
      ),
    );
  }
  Color get color{
    switch(noteState)
    {
      case NoteState.ReadyState :
        return Colors.black;
      case NoteState.MissedState :
        return Colors.red;
      case NoteState.TappedState :
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}

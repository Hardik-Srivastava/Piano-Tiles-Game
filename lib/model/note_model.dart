import 'package:pianotiles/provider/note_state.dart';

class NoteModel{
  final int ordernumber;
  final int line;

  NoteState noteState = NoteState.ReadyState;
  NoteModel(this.ordernumber, this.line);
}

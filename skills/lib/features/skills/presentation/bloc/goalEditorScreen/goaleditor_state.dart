import 'package:equatable/equatable.dart';

abstract class GoaleditorState extends Equatable {
  const GoaleditorState();
}

class InitialGoaleditorState extends GoaleditorState {
  @override
  List<Object> get props => [];
}

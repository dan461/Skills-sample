import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SkillsEvent extends Equatable {
  const SkillsEvent();
}

class GetAllSkillsEvent extends SkillsEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
  
}

class GetSkillByIdEvent extends SkillsEvent {
  final int id;

  GetSkillByIdEvent({@required this.id});

  @override
  List<Object> get props => [id];
}

// class InsertNewSkillEvent extends SkillsEvent {
//   @override
//   // TODO: implement props
//   List<Object> get props => null;
  
// }

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  final int id;
  final String name;
  final String source;
  final int startDate;
  final int totalTime;

  Skill({
    this.id,
    @required this.name,
    @required this.source,
    this.startDate,
    this.totalTime,
  }) : super();

  @override
  List<Object> get props => [id,name,source,startDate,totalTime];

//  Skill({int id, String name, String source}) {
//    this.id = id;
//    this.name = name;
//    this.source = source;
//  }
}

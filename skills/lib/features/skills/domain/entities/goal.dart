import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Goal extends Equatable {

  final int id;
  final int fromDate;
  final int toDate;
  final bool timeBased;
  final int goalTime;
  final String desc;
  

  Goal({
    this.id,
    @required this.fromDate,
    @required this.toDate,
    @required this.timeBased,
    @required this.goalTime,
    this.desc

  }) : super();


  @override
  List<Object> get props => [id, fromDate, toDate, timeBased, goalTime, desc];
  
}
import 'package:dartz/dartz.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

abstract class SkillEventRepository {
  Future<Either<Failure, SkillEvent>> insertNewEvent(SkillEvent event);
  Future<Either<Failure, List<int>>> insertEvents(List<SkillEvent> events, int newSessionId);
  Future<Either<Failure, SkillEvent>> getEventById(int id);
  Future<Either<Failure, int>> updateEvent(SkillEvent event);
  Future<Either<Failure, int>> deleteEventById(int id);
  Future<Either<Failure, List<SkillEvent>>> getEventsForSession(int sessionId);
  Future<Either<Failure, List<Map>>> getInfoForEvents(List<SkillEvent> events);
  Future<Either<Failure, List<Map>>> getEventMapsForSession(int sessionId);
  
  


  
}
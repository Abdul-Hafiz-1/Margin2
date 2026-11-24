import '../models/models.dart';

abstract class TeamRepository {
  Future<List<TeamMember>> getMembers();

  Future<void> addMember(TeamMember member);

  Future<List<TeamMessage>> getMessages();

  Future<void> sendMessage(TeamMessage message);

  Stream<List<TeamMessage>> watchMessages();
}

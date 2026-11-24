import 'dart:async';
import 'package:hive/hive.dart';
import '../../models/models.dart';
import '../../services/storage_service.dart';
import '../team_repository.dart';

class LocalTeamRepository implements TeamRepository {
  final StorageService _storageService;

  LocalTeamRepository([StorageService? storageService])
      : _storageService = storageService ?? StorageService.instance;

  Box get _membersBox => _storageService.teamMembersBox;
  Box get _messagesBox => _storageService.teamMessagesBox;

  @override
  Future<List<TeamMember>> getMembers() async {
    final rawList = _membersBox.values;
    final members = <TeamMember>[];

    for (final raw in rawList) {
      try {
        final map = (raw as Map).cast<String, dynamic>();
        members.add(TeamMember.fromMap(map));
      } catch (_) {}
    }
    return members;
  }

  @override
  Future<void> addMember(TeamMember member) async {
    await _membersBox.put(member.id, member.toMap());
  }

  @override
  Future<List<TeamMessage>> getMessages() async {
    final rawList = _messagesBox.values;
    final messages = <TeamMessage>[];

    for (final raw in rawList) {
      try {
        final map = (raw as Map).cast<String, dynamic>();
        messages.add(TeamMessage.fromMap(map));
      } catch (_) {}
    }

    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  @override
  Future<void> sendMessage(TeamMessage message) async {
    await _messagesBox.put(message.id, message.toMap());
  }

  @override
  Stream<List<TeamMessage>> watchMessages() {
    return _messagesBox.watch().asyncMap((_) => getMessages());
  }
}

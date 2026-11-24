class JournalEntry {
  final String id;
  String title;
  String content;
  final String? originalTranscription;
  final DateTime createdAt;
  DateTime updatedAt;
  List<String> tags;
  String? linkedProjectId;
  String? linkedProjectName;
  bool isDraft;
  bool isVoice;
  int audioDurationSeconds;
  bool isAnalyzed;
  AIInsight? insight;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    this.originalTranscription,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.linkedProjectId,
    this.linkedProjectName,
    this.isDraft = false,
    this.isVoice = false,
    this.audioDurationSeconds = 0,
    this.isAnalyzed = false,
    this.insight,
  });
}

class AIInsight {
  final String detectedTitle;
  final String ideaDescription;
  final String category;
  final String priority;
  final String timeline;
  final List<String> keyPoints;
  final List<ActionPlanItem> actionPlan;
  final bool isCloudAnalyzed;

  AIInsight({
    required this.detectedTitle,
    required this.ideaDescription,
    required this.category,
    required this.priority,
    required this.timeline,
    required this.keyPoints,
    required this.actionPlan,
    this.isCloudAnalyzed = false,
  });
}

class ActionPlanItem {
  final String id;
  String title;
  bool isSelected;

  ActionPlanItem({
    required this.id,
    required this.title,
    this.isSelected = true,
  });
}

enum TaskPriority { low, medium, high }

class TaskItem {
  final String id;
  String title;
  String? description;
  bool isCompleted;
  TaskPriority priority;
  DateTime? dueDate;
  String? projectId;
  String? projectName;
  String? sourceJournalId;
  String? assignee;
  List<String> subtasks;

  TaskItem({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.projectId,
    this.projectName,
    this.sourceJournalId,
    this.assignee,
    this.subtasks = const [],
  });
}

class Project {
  final String id;
  String name;
  String category;
  String description;
  double progress;
  TaskPriority priority;
  String nextMilestone;
  DateTime? dueDate;
  int colorValue;
  String iconName;
  int memberCount;
  List<String> decisions;
  bool isArchived;

  Project({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.progress = 0.0,
    this.priority = TaskPriority.medium,
    required this.nextMilestone,
    this.dueDate,
    required this.colorValue,
    required this.iconName,
    this.memberCount = 1,
    this.decisions = const [],
    this.isArchived = false,
  });
}

class TeamMember {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final int colorValue;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.colorValue,
  });
}

class TeamMessage {
  final String id;
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isFromMargo;
  final List<String>? suggestions;

  TeamMessage({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isFromMargo = false,
    this.suggestions,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String timeAgo;
  final String type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });
}

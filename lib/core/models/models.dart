import 'dart:convert';

enum TaskPriority { low, medium, high }

extension TaskPriorityExtension on TaskPriority {
  String toShortString() => toString().split('.').last;

  static TaskPriority fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'high':
        return TaskPriority.high;
      case 'medium':
        return TaskPriority.medium;
      case 'low':
      default:
        return TaskPriority.low;
    }
  }
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isSelected': isSelected,
    };
  }

  factory ActionPlanItem.fromMap(Map<String, dynamic> map) {
    return ActionPlanItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      isSelected: map['isSelected'] as bool? ?? true,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory ActionPlanItem.fromJson(String source) =>
      ActionPlanItem.fromMap(jsonDecode(source) as Map<String, dynamic>);

  ActionPlanItem copyWith({
    String? id,
    String? title,
    bool? isSelected,
  }) {
    return ActionPlanItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'detectedTitle': detectedTitle,
      'ideaDescription': ideaDescription,
      'category': category,
      'priority': priority,
      'timeline': timeline,
      'keyPoints': keyPoints,
      'actionPlan': actionPlan.map((x) => x.toMap()).toList(),
      'isCloudAnalyzed': isCloudAnalyzed,
    };
  }

  factory AIInsight.fromMap(Map<String, dynamic> map) {
    return AIInsight(
      detectedTitle: map['detectedTitle'] as String? ?? '',
      ideaDescription: map['ideaDescription'] as String? ?? '',
      category: map['category'] as String? ?? '',
      priority: map['priority'] as String? ?? 'Medium',
      timeline: map['timeline'] as String? ?? '',
      keyPoints: (map['keyPoints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      actionPlan: (map['actionPlan'] as List<dynamic>?)
              ?.map((e) => ActionPlanItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      isCloudAnalyzed: map['isCloudAnalyzed'] as bool? ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory AIInsight.fromJson(String source) =>
      AIInsight.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'originalTranscription': originalTranscription,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'linkedProjectId': linkedProjectId,
      'linkedProjectName': linkedProjectName,
      'isDraft': isDraft,
      'isVoice': isVoice,
      'audioDurationSeconds': audioDurationSeconds,
      'isAnalyzed': isAnalyzed,
      'insight': insight?.toMap(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      originalTranscription: map['originalTranscription'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      tags: (map['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      linkedProjectId: map['linkedProjectId'] as String?,
      linkedProjectName: map['linkedProjectName'] as String?,
      isDraft: map['isDraft'] as bool? ?? false,
      isVoice: map['isVoice'] as bool? ?? false,
      audioDurationSeconds: (map['audioDurationSeconds'] as num?)?.toInt() ?? 0,
      isAnalyzed: map['isAnalyzed'] as bool? ?? false,
      insight: map['insight'] != null
          ? AIInsight.fromMap(map['insight'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory JournalEntry.fromJson(String source) =>
      JournalEntry.fromMap(jsonDecode(source) as Map<String, dynamic>);

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? originalTranscription,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? linkedProjectId,
    String? linkedProjectName,
    bool? isDraft,
    bool? isVoice,
    int? audioDurationSeconds,
    bool? isAnalyzed,
    AIInsight? insight,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      originalTranscription:
          originalTranscription ?? this.originalTranscription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? List.from(this.tags),
      linkedProjectId: linkedProjectId ?? this.linkedProjectId,
      linkedProjectName: linkedProjectName ?? this.linkedProjectName,
      isDraft: isDraft ?? this.isDraft,
      isVoice: isVoice ?? this.isVoice,
      audioDurationSeconds:
          audioDurationSeconds ?? this.audioDurationSeconds,
      isAnalyzed: isAnalyzed ?? this.isAnalyzed,
      insight: insight ?? this.insight,
    );
  }
}

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.toShortString(),
      'dueDate': dueDate?.toIso8601String(),
      'projectId': projectId,
      'projectName': projectName,
      'sourceJournalId': sourceJournalId,
      'assignee': assignee,
      'subtasks': subtasks,
    };
  }

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      isCompleted: map['isCompleted'] as bool? ?? false,
      priority: TaskPriorityExtension.fromString(map['priority'] as String?),
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'].toString())
          : null,
      projectId: map['projectId'] as String?,
      projectName: map['projectName'] as String?,
      sourceJournalId: map['sourceJournalId'] as String?,
      assignee: map['assignee'] as String?,
      subtasks: (map['subtasks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  String toJson() => jsonEncode(toMap());
  factory TaskItem.fromJson(String source) =>
      TaskItem.fromMap(jsonDecode(source) as Map<String, dynamic>);

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? dueDate,
    String? projectId,
    String? projectName,
    String? sourceJournalId,
    String? assignee,
    List<String>? subtasks,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      sourceJournalId: sourceJournalId ?? this.sourceJournalId,
      assignee: assignee ?? this.assignee,
      subtasks: subtasks ?? List.from(this.subtasks),
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'progress': progress,
      'priority': priority.toShortString(),
      'nextMilestone': nextMilestone,
      'dueDate': dueDate?.toIso8601String(),
      'colorValue': colorValue,
      'iconName': iconName,
      'memberCount': memberCount,
      'decisions': decisions,
      'isArchived': isArchived,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      description: map['description'] as String? ?? '',
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      priority: TaskPriorityExtension.fromString(map['priority'] as String?),
      nextMilestone: map['nextMilestone'] as String? ?? '',
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'].toString())
          : null,
      colorValue: (map['colorValue'] as num?)?.toInt() ?? 0xFF7655E8,
      iconName: map['iconName'] as String? ?? 'sparkles',
      memberCount: (map['memberCount'] as num?)?.toInt() ?? 1,
      decisions: (map['decisions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isArchived: map['isArchived'] as bool? ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Project.fromJson(String source) =>
      Project.fromMap(jsonDecode(source) as Map<String, dynamic>);

  Project copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    double? progress,
    TaskPriority? priority,
    String? nextMilestone,
    DateTime? dueDate,
    int? colorValue,
    String? iconName,
    int? memberCount,
    List<String>? decisions,
    bool? isArchived,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      priority: priority ?? this.priority,
      nextMilestone: nextMilestone ?? this.nextMilestone,
      dueDate: dueDate ?? this.dueDate,
      colorValue: colorValue ?? this.colorValue,
      iconName: iconName ?? this.iconName,
      memberCount: memberCount ?? this.memberCount,
      decisions: decisions ?? List.from(this.decisions),
      isArchived: isArchived ?? this.isArchived,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'avatarUrl': avatarUrl,
      'colorValue': colorValue,
    };
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String? ?? '',
      colorValue: (map['colorValue'] as num?)?.toInt() ?? 0xFF7655E8,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory TeamMember.fromJson(String source) =>
      TeamMember.fromMap(jsonDecode(source) as Map<String, dynamic>);
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isFromMargo': isFromMargo,
      'suggestions': suggestions,
    };
  }

  factory TeamMessage.fromMap(Map<String, dynamic> map) {
    return TeamMessage(
      id: map['id'] as String? ?? '',
      sender: map['sender'] as String? ?? '',
      message: map['message'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isFromMargo: map['isFromMargo'] as bool? ?? false,
      suggestions: (map['suggestions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory TeamMessage.fromJson(String source) =>
      TeamMessage.fromMap(jsonDecode(source) as Map<String, dynamic>);
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'timeAgo': timeAgo,
      'type': type,
      'isRead': isRead,
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      timeAgo: map['timeAgo'] as String? ?? '',
      type: map['type'] as String? ?? '',
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory NotificationItem.fromJson(String source) =>
      NotificationItem.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

/// Offline mutation queue model for reliable background synchronization.
class SyncOperation {
  final String id;
  final String entityType; // 'journal', 'project', 'task', etc.
  final String entityId;
  final String action; // 'create', 'update', 'delete'
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  int retryCount;
  String status; // 'pending', 'syncing', 'failed'

  SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.payload,
    required this.timestamp,
    this.retryCount = 0,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entityType': entityType,
      'entityId': entityId,
      'action': action,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'retryCount': retryCount,
      'status': status,
    };
  }

  factory SyncOperation.fromMap(Map<String, dynamic> map) {
    return SyncOperation(
      id: map['id'] as String? ?? '',
      entityType: map['entityType'] as String? ?? '',
      entityId: map['entityId'] as String? ?? '',
      action: map['action'] as String? ?? '',
      payload: (map['payload'] as Map<dynamic, dynamic>?)?.cast<String, dynamic>() ?? {},
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      retryCount: (map['retryCount'] as num?)?.toInt() ?? 0,
      status: map['status'] as String? ?? 'pending',
    );
  }

  String toJson() => jsonEncode(toMap());
  factory SyncOperation.fromJson(String source) =>
      SyncOperation.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

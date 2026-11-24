import 'package:flutter/material.dart';
import '../models/models.dart';
import '../../theme/colors.dart';

class StateService extends ChangeNotifier {
  static final StateService instance = StateService._internal();
  StateService._internal() {
    _initSeedData();
  }

  String userName = "Abdul";
  String userEmail = "abdul@margin.app";
  String workspaceName = "Personal Workspace";

  List<JournalEntry> journalEntries = [];
  List<Project> projects = [];
  List<TaskItem> tasks = [];
  List<TeamMember> teamMembers = [];
  List<TeamMessage> teamMessages = [];
  List<NotificationItem> notifications = [];

  String? currentFocusProjectId;

  void _initSeedData() {
    // Seed Projects matching moodboard
    projects = [
      Project(
        id: "proj_1",
        name: "MARGIN",
        category: "Product",
        description: "Intelligent personal journal and creative workspace app with hybrid on-device AI.",
        progress: 0.85,
        priority: TaskPriority.high,
        nextMilestone: "UI Design System & Hybrid AI Engine",
        dueDate: DateTime.now().add(const Duration(days: 2)),
        colorValue: MarginColors.purple.toARGB32(),
        iconName: "sparkles",
        memberCount: 4,
        decisions: [
          "Use Quicksand for headings and Inter for dense metadata",
          "Margo mascot is an accent, not the main interface",
          "Hybrid on-device processing for privacy with cloud fallback",
        ],
      ),
      Project(
        id: "proj_2",
        name: "YouTube Channel",
        category: "Creator",
        description: "Design-engineering tutorials and creative productivity dev logs.",
        progress: 0.55,
        priority: TaskPriority.medium,
        nextMilestone: "Record first 3 episodes",
        dueDate: DateTime.now().add(const Duration(days: 6)),
        colorValue: MarginColors.softPeach.toARGB32(),
        iconName: "play",
        memberCount: 2,
        decisions: [
          "Record in 4K with desk mic",
          "Publish every Sunday",
        ],
      ),
      Project(
        id: "proj_3",
        name: "Clothing Brand",
        category: "Business",
        description: "Minimal oversized heavyweight streetwear capsule collection.",
        progress: 0.25,
        priority: TaskPriority.high,
        nextMilestone: "Supplier samples & mockups",
        dueDate: DateTime.now().add(const Duration(days: 18)),
        colorValue: MarginColors.sky.toARGB32(),
        iconName: "shirt",
        memberCount: 3,
        decisions: [
          "100% heavyweight 280gsm organic cotton",
          "Embroidered tonal branding only",
        ],
      ),
      Project(
        id: "proj_4",
        name: "Personal Goals",
        category: "Self-Improvement",
        description: "Fitness routine, daily reading, and mindful journaling habits.",
        progress: 0.45,
        priority: TaskPriority.medium,
        nextMilestone: "Complete 14-day streak",
        dueDate: DateTime.now().add(const Duration(days: 10)),
        colorValue: MarginColors.mint.toARGB32(),
        iconName: "leaf",
        memberCount: 1,
        decisions: [],
      ),
    ];

    currentFocusProjectId = "proj_1";

    // Seed Tasks matching moodboard
    tasks = [
      TaskItem(
        id: "t_1",
        title: "Research manufacturers",
        description: "Look into certified organic cotton factories in Portugal and local print suppliers.",
        isCompleted: false,
        priority: TaskPriority.high,
        dueDate: DateTime.now(),
        projectId: "proj_3",
        projectName: "Clothing Brand",
      ),
      TaskItem(
        id: "t_2",
        title: "Create 3 T-shirt designs",
        description: "Minimal typography on back, subtle chest monogram, boxy drop shoulder cut.",
        isCompleted: false,
        priority: TaskPriority.medium,
        dueDate: DateTime.now(),
        projectId: "proj_3",
        projectName: "Clothing Brand",
      ),
      TaskItem(
        id: "t_3",
        title: "Plan YouTube content",
        description: "Script breakdown for: 'How we built an AI journal that respects privacy'.",
        isCompleted: true,
        priority: TaskPriority.medium,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        projectId: "proj_2",
        projectName: "YouTube Channel",
      ),
      TaskItem(
        id: "t_4",
        title: "Study for Maths test",
        description: "Linear algebra, matrix operations and probability fundamentals.",
        isCompleted: false,
        priority: TaskPriority.high,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        projectId: "proj_4",
        projectName: "Personal Goals",
      ),
      TaskItem(
        id: "t_5",
        title: "Finalize MARGIN Design Tokens",
        description: "Color tokens, typography hierarchy, Margo animation states.",
        isCompleted: true,
        priority: TaskPriority.high,
        dueDate: DateTime.now(),
        projectId: "proj_1",
        projectName: "MARGIN",
      ),
    ];

    // Seed Journal Entries matching user prompt
    journalEntries = [
      JournalEntry(
        id: "j_1",
        title: "Starting a clothing brand idea",
        content:
            "I've been thinking about starting a clothing brand. Maybe minimal oversized T-shirts. I need to research manufacturers, understand the costs, create a logo, and discuss it with my friends. I don't really know where to start.",
        originalTranscription:
            "I've been thinking about starting a clothing brand. Maybe minimal oversized T-shirts. I need to research manufacturers, understand the costs, create a logo, and discuss it with my friends. I don't really know where to start.",
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        tags: ["Business", "Ideas", "Streetwear"],
        linkedProjectId: "proj_3",
        linkedProjectName: "Clothing Brand",
        isVoice: true,
        audioDurationSeconds: 42,
        isAnalyzed: true,
      ),
      JournalEntry(
        id: "j_2",
        title: "Why software should feel like a journal",
        content:
            "Most productivity software feels like filling out tickets for a boss. MARGIN should feel like sitting at a warm wooden desk with soft morning light, sketching thoughts in a moleskine journal where an intelligent friend gently offers clarity.",
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        tags: ["Product", "Philosophy", "Design"],
        linkedProjectId: "proj_1",
        linkedProjectName: "MARGIN",
        isVoice: false,
        isAnalyzed: true,
      ),
      JournalEntry(
        id: "j_3",
        title: "Camera angles and lighting for desk studio",
        content:
            "Top-down camera mount works best for sketching and typing. Need a soft key light at 45 degrees to avoid harsh glare on glasses.",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        tags: ["Creator", "Setup"],
        linkedProjectId: "proj_2",
        linkedProjectName: "YouTube Channel",
        isVoice: false,
        isAnalyzed: false,
      ),
    ];

    // Seed Team Members
    teamMembers = [
      TeamMember(
        id: "m_1",
        name: "Abdul",
        role: "Owner",
        avatarUrl: "",
        colorValue: MarginColors.purple.toARGB32(),
      ),
      TeamMember(
        id: "m_2",
        name: "Ayesha",
        role: "Lead Designer",
        avatarUrl: "",
        colorValue: MarginColors.softPeach.toARGB32(),
      ),
      TeamMember(
        id: "m_3",
        name: "Devin",
        role: "AI Engineer",
        avatarUrl: "",
        colorValue: MarginColors.sky.toARGB32(),
      ),
      TeamMember(
        id: "m_4",
        name: "Sophie",
        role: "Content Lead",
        avatarUrl: "",
        colorValue: MarginColors.mint.toARGB32(),
      ),
    ];

    // Seed Team Chat Messages
    teamMessages = [
      TeamMessage(
        id: "msg_1",
        sender: "Ayesha",
        message: "Should we go with the minimal logo or the lettermark?",
        timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
      TeamMessage(
        id: "msg_2",
        sender: "Margo",
        message: "Here are 3 subtle logo directions matching your minimal aesthetic:",
        timestamp: DateTime.now().subtract(const Duration(minutes: 17)),
        isFromMargo: true,
        suggestions: [
          "M — Clean architectural monogram",
          "MARGIN — Spaced out lowercase wordmark",
          "• M • — Monogram with framing dots",
        ],
      ),
      TeamMessage(
        id: "msg_3",
        sender: "Abdul",
        message: "I love direction #2. Let's test that on the sample T-shirts!",
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
    ];

    // Seed Notifications
    notifications = [
      NotificationItem(
        id: "n_1",
        title: "New AI Insight ready",
        subtitle: "Margo extracted 5 actionable steps for 'Clothing Brand'",
        timeAgo: "10m ago",
        type: "insight",
      ),
      NotificationItem(
        id: "n_2",
        title: "Milestone approaching",
        subtitle: "'MARGIN' project due in 2 days (85% completed)",
        timeAgo: "1h ago",
        type: "deadline",
      ),
      NotificationItem(
        id: "n_3",
        title: "Ayesha mentioned you",
        subtitle: "In team discussion: 'Should we go with the minimal logo?'",
        timeAgo: "3h ago",
        type: "team",
      ),
    ];
  }

  Project? get currentFocusProject {
    if (currentFocusProjectId == null) return null;
    return projects.firstWhere(
      (p) => p.id == currentFocusProjectId,
      orElse: () => projects.first,
    );
  }

  void setFocusProject(String projectId) {
    currentFocusProjectId = projectId;
    notifyListeners();
  }

  void addJournalEntry(JournalEntry entry) {
    journalEntries.insert(0, entry);
    notifyListeners();
  }

  void updateJournalEntry(JournalEntry entry) {
    final index = journalEntries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      journalEntries[index] = entry;
      notifyListeners();
    }
  }

  void deleteJournalEntry(String id) {
    journalEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final task = tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void addTask(TaskItem task) {
    tasks.insert(0, task);
    notifyListeners();
  }

  void addProject(Project project) {
    projects.add(project);
    notifyListeners();
  }

  void addTeamMessage(TeamMessage message) {
    teamMessages.add(message);
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final notif = notifications.firstWhere((n) => n.id == id);
    notif.isRead = true;
    notifyListeners();
  }
}

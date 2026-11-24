import 'package:flutter/material.dart';
import '../core/models/models.dart';
import '../theme/theme.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../shared/margo/margo_widget.dart';
import '../shared/margo/margo_states.dart';
import '../shared/components/bottom_nav.dart';
import '../shared/components/ai_processing_indicator.dart';

// Screens
import '../features/onboarding/splash_screen.dart';
import '../features/onboarding/welcome_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/permissions_screen.dart';
import '../features/onboarding/auth_screen.dart';
import '../features/home/home_dashboard_screen.dart';
import '../features/home/celebration_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/journal/thought_capture_screen.dart';
import '../features/journal/saved_entry_screen.dart';
import '../features/intelligence/ai_analysis_screen.dart';
import '../features/intelligence/ai_insights_screen.dart';
import '../features/intelligence/project_blueprint_screen.dart';
import '../features/projects/projects_screen.dart';
import '../features/projects/project_detail_screen.dart';
import '../features/tasks/tasks_screen.dart';
import '../features/priorities/priorities_screen.dart';
import '../features/teams/teams_screen.dart';
import '../features/teams/invite_members_sheet.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';

class MarginApp extends StatelessWidget {
  const MarginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MARGIN',
      debugShowCheckedModeBanner: false,
      theme: MarginTheme.lightTheme,
      darkTheme: MarginTheme.darkTheme,
      themeMode: ThemeMode.dark, // Midnight Bloom is primary identity
      home: const MainNavigationShell(),
    );
  }
}

enum AppFlowStep {
  splash,
  welcome,
  onboarding,
  permissions,
  auth,
  workspace,
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  AppFlowStep _currentFlow = AppFlowStep.splash;
  int _selectedTab = 0; // 0: Home, 1: Journal, 2: Projects, 3: Teams

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _openCapture({JournalEntry? entry, bool voiceMode = false}) {
    _navigateTo(
      ThoughtCaptureScreen(
        initialEntry: entry,
        startInVoiceMode: voiceMode,
        onSaved: (saved) {
          Navigator.pop(context);
        },
        onAnalyzeImmediately: (entryToAnalyze) {
          Navigator.pop(context);
          _startAnalysis(entryToAnalyze);
        },
      ),
    );
  }

  void _startAnalysis(JournalEntry entry) {
    _navigateTo(
      AIAnalysisScreen(
        entry: entry,
        onAnalysisComplete: (insight) {
          Navigator.pop(context); // pop analysis
          _openInsights(entry, insight);
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openInsights(JournalEntry entry, AIInsight insight) {
    _navigateTo(
      AIInsightsScreen(
        entry: entry,
        initialInsight: insight,
        onOpenBlueprint: () {
          _navigateTo(ProjectBlueprintScreen(entry: entry));
        },
        onProjectCreated: (project) {
          Navigator.pop(context); // pop insights
          _openProjectDetail(project);
        },
      ),
    );
  }

  void _openProjectDetail(Project project) {
    _navigateTo(
      ProjectDetailScreen(
        project: project,
        onOpenBlueprint: () {
          final dummyEntry = JournalEntry(
            id: "blueprint_ref",
            title: project.name,
            content: project.description,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          _navigateTo(ProjectBlueprintScreen(entry: dummyEntry));
        },
      ),
    );
  }

  void _openSavedEntry(JournalEntry entry) {
    _navigateTo(
      SavedEntryScreen(
        entry: entry,
        onEdit: () {
          Navigator.pop(context);
          _openCapture(entry: entry);
        },
        onAnalyze: () {
          Navigator.pop(context);
          _startAnalysis(entry);
        },
        onDeleted: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Phase A Launch Flow
    switch (_currentFlow) {
      case AppFlowStep.splash:
        return SplashScreen(
          onContinue: () => setState(() => _currentFlow = AppFlowStep.welcome),
        );
      case AppFlowStep.welcome:
        return WelcomeScreen(
          onGetStarted: () => setState(() => _currentFlow = AppFlowStep.onboarding),
          onLogin: () => setState(() => _currentFlow = AppFlowStep.auth),
        );
      case AppFlowStep.onboarding:
        return OnboardingScreen(
          onFinish: () => setState(() => _currentFlow = AppFlowStep.permissions),
        );
      case AppFlowStep.permissions:
        return PermissionsScreen(
          onContinue: () => setState(() => _currentFlow = AppFlowStep.auth),
        );
      case AppFlowStep.auth:
        return AuthScreen(
          onAuthenticated: () => setState(() => _currentFlow = AppFlowStep.workspace),
        );
      case AppFlowStep.workspace:
        return _buildWorkspace(context);
    }
  }

  Widget _buildWorkspace(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktopOrTablet = width >= 800;

    // Body based on active tab
    Widget activeBody;
    switch (_selectedTab) {
      case 0:
        activeBody = HomeDashboardScreen(
          onOpenCapture: () => _openCapture(),
          onOpenVoiceCapture: () => _openCapture(voiceMode: true),
          onOpenNotifications: () => _navigateTo(const NotificationsScreen()),
          onOpenProfile: () => _navigateTo(
            SettingsScreen(
              onShowCelebration: () => _navigateTo(
                CelebrationScreen(onDismiss: () => Navigator.pop(context)),
              ),
            ),
          ),
          onSelectProject: _openProjectDetail,
          onSelectEntry: _openSavedEntry,
          onSeeAllProjects: () => setState(() => _selectedTab = 2),
          onSeeAllTasks: () => _navigateTo(
            TasksScreen(
              onOpenPriorities: () => _navigateTo(
                PrioritiesScreen(onSelectProject: _openProjectDetail),
              ),
            ),
          ),
        );
        break;
      case 1:
        activeBody = JournalScreen(
          onSelectEntry: _openSavedEntry,
          onAnalyzeEntry: _startAnalysis,
          onNewEntry: () => _openCapture(),
        );
        break;
      case 2:
        activeBody = ProjectsScreen(
          onSelectProject: _openProjectDetail,
          onCreateProject: () => _openCapture(),
        );
        break;
      case 3:
        activeBody = TeamsScreen(
          onInviteTap: () => InviteMembersSheet.show(context),
        );
        break;
      default:
        activeBody = const SizedBox();
    }

    // Tablet & Desktop Responsive Layout with Collapsible Sidebar
    if (isDesktopOrTablet) {
      return Scaffold(
        body: Row(
          children: [
            // Left Sidebar
            Container(
              width: 250,
              decoration: const BoxDecoration(
                color: MarginColors.surface,
                border: Border(
                  right: BorderSide(color: MarginColors.border, width: 1.0),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Header
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const MargoWidget(mood: MargoMood.idle, size: 38),
                          const SizedBox(width: 10),
                          Text(
                            "MARGIN",
                            style: MarginTypography.headingLarge.copyWith(
                              letterSpacing: 2,
                              color: MarginColors.lavender,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: AIProcessingIndicator(),
                    ),
                    const SizedBox(height: 20),
                    // Nav Items
                    _buildSidebarItem(0, Icons.home_rounded, "Home"),
                    _buildSidebarItem(1, Icons.book_rounded, "Journal"),
                    _buildSidebarItem(2, Icons.folder_rounded, "Projects"),
                    _buildSidebarItem(3, Icons.group_rounded, "Teams"),
                    const Divider(height: 32),
                    // Secondary destinations
                    ListTile(
                      leading: const Icon(Icons.check_circle_outline_rounded, color: MarginColors.textSecondary),
                      title: Text("Tasks", style: MarginTypography.bodyMediumBold),
                      onTap: () => _navigateTo(
                        TasksScreen(
                          onOpenPriorities: () => _navigateTo(
                            PrioritiesScreen(onSelectProject: _openProjectDetail),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.bolt_rounded, color: MarginColors.lavender),
                      title: Text("Attention & Focus", style: MarginTypography.bodyMediumBold),
                      onTap: () => _navigateTo(
                        PrioritiesScreen(onSelectProject: _openProjectDetail),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.search_rounded, color: MarginColors.textSecondary),
                      title: Text("Search", style: MarginTypography.bodyMediumBold),
                      onTap: () => _navigateTo(
                        GlobalSearchScreen(
                          onSelectProject: _openProjectDetail,
                          onSelectEntry: _openSavedEntry,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Bottom Profile / Settings button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _navigateTo(
                            SettingsScreen(
                              onShowCelebration: () => _navigateTo(
                                CelebrationScreen(onDismiss: () => Navigator.pop(context)),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.settings_outlined, size: 18),
                          label: const Text("Settings"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Main Content Area
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: activeBody,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Mobile-First Layout with Bottom Navigation & Center Capture Button
    return Scaffold(
      body: activeBody,
      bottomNavigationBar: MarginBottomNav(
        currentIndex: _selectedTab,
        onTabSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        onCaptureTap: () => _openCapture(),
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: isSelected ? MarginColors.elevated : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: MarginColors.border) : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? MarginColors.lavender : MarginColors.textMuted),
        title: Text(
          label,
          style: MarginTypography.bodyMediumBold.copyWith(
            color: isSelected ? MarginColors.textPrimary : MarginColors.textSecondary,
          ),
        ),
        onTap: () => setState(() => _selectedTab = index),
      ),
    );
  }
}

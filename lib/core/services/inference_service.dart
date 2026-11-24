import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

enum AIConnectionState {
  localReady,
  cloudReady,
  hybridReady,
  offline,
  localUnavailableCloudFallback,
  waitingForPermission,
}

enum InferenceMode {
  automatic,
  preferLocal,
  cloudOnly,
}

class InferenceService extends ChangeNotifier {
  static final InferenceService instance = InferenceService._internal();
  InferenceService._internal();

  AIConnectionState _connectionState = AIConnectionState.hybridReady;
  bool _preferLocal = true;
  bool _hasCloudConsent = true;

  AIConnectionState get connectionState => _connectionState;
  bool get preferLocal => _preferLocal;
  bool get hasCloudConsent => _hasCloudConsent;

  void setPreferLocal(bool value) {
    _preferLocal = value;
    notifyListeners();
  }

  void setCloudConsent(bool value) {
    _hasCloudConsent = value;
    notifyListeners();
  }

  void setConnectionState(AIConnectionState state) {
    _connectionState = state;
    notifyListeners();
  }

  String getConnectionStateLabel() {
    switch (_connectionState) {
      case AIConnectionState.localReady:
        return "On-device AI ready (Private & offline)";
      case AIConnectionState.cloudReady:
        return "Cloud AI connected (High reasoning)";
      case AIConnectionState.hybridReady:
        return "Hybrid AI active (Local-first + Cloud)";
      case AIConnectionState.offline:
        return "Offline — Queueing for local sync";
      case AIConnectionState.localUnavailableCloudFallback:
        return "Local unavailable — using Cloud fallback";
      case AIConnectionState.waitingForPermission:
        return "Waiting for cloud processing permission";
    }
  }

  /// Extracts insights and actionable steps from user thoughts.
  /// Mimics real multi-stage reasoning with granular step callbacks.
  Stream<String> analyzeThoughtStream(
    String thoughtText, {
    bool isBlueprint = false,
  }) async* {
    yield "Understanding your thoughts...";
    await Future.delayed(const Duration(milliseconds: 700));

    yield "Finding key ideas and themes...";
    await Future.delayed(const Duration(milliseconds: 700));

    if (isBlueprint || !_preferLocal) {
      yield "Connecting strategic milestones...";
      await Future.delayed(const Duration(milliseconds: 800));
      yield "Synthesizing deep project blueprint...";
      await Future.delayed(const Duration(milliseconds: 700));
    } else {
      yield "Extracting actionable next steps on-device...";
      await Future.delayed(const Duration(milliseconds: 600));
    }

    yield "Ready!";
  }

  AIInsight generateInsightForText(String text) {
    final lower = text.toLowerCase();

    if (lower.contains("cloth") || lower.contains("brand") || lower.contains("t-shirt") || lower.contains("shirt")) {
      return AIInsight(
        detectedTitle: "Start a Clothing Brand",
        ideaDescription: "A minimal, oversized streetwear label starting with high-quality basics and community feedback.",
        category: "Business / Creative",
        priority: "High",
        timeline: "2–4 weeks",
        keyPoints: [
          "Minimal oversized T-shirts as initial hero product line.",
          "Target sustainable, heavy-weight cotton fabrics.",
          "Need to research local & offshore manufacturers.",
          "Initial production cost estimation and MOQ calculations.",
          "Brand identity, typography and subtle logo exploration.",
          "Validate concept with close friends & streetwear poll.",
        ],
        actionPlan: [
          ActionPlanItem(id: "1", title: "Research 3 potential garment manufacturers"),
          ActionPlanItem(id: "2", title: "Estimate production costs & minimum order quantities"),
          ActionPlanItem(id: "3", title: "Sketch initial brand logo and aesthetic moodboard"),
          ActionPlanItem(id: "4", title: "Gather feedback from friends on mockup cuts"),
          ActionPlanItem(id: "5", title: "Define pricing model and landing page waitlist"),
        ],
        isCloudAnalyzed: !_preferLocal,
      );
    } else if (lower.contains("youtube") || lower.contains("video") || lower.contains("content")) {
      return AIInsight(
        detectedTitle: "Launch YouTube Content Pipeline",
        ideaDescription: "Educational & aesthetic tech storytelling channel focusing on building modern products.",
        category: "Creator",
        priority: "Medium",
        timeline: "1–2 weeks",
        keyPoints: [
          "Focus on hands-on build logs and high-aesthetic tutorials.",
          "Script structure: Hook -> Problem -> Solution -> Reveal.",
          "Batch record 3 videos before publishing channel trailer.",
        ],
        actionPlan: [
          ActionPlanItem(id: "1", title: "Outline first 3 video scripts and titles"),
          ActionPlanItem(id: "2", title: "Setup lighting & desk audio recording rig"),
          ActionPlanItem(id: "3", title: "Design YouTube channel banner and thumbnail template"),
        ],
        isCloudAnalyzed: !_preferLocal,
      );
    } else {
      return AIInsight(
        detectedTitle: text.trim().split("\n").first.take(35),
        ideaDescription: "Extracted structure from your journal notes with tangible next steps.",
        category: "Personal Focus",
        priority: "Medium",
        timeline: "1 week",
        keyPoints: [
          "Core objective identified from thoughts.",
          "Key priorities isolated for immediate action.",
          "Schedule reflection check-in after initial progress.",
        ],
        actionPlan: [
          ActionPlanItem(id: "1", title: "Review requirements and break into milestones"),
          ActionPlanItem(id: "2", title: "Schedule 45 minutes of uninterrupted focus time"),
          ActionPlanItem(id: "3", title: "Check off first tangible milestone"),
        ],
        isCloudAnalyzed: !_preferLocal,
      );
    }
  }
}

extension StringExtension on String {
  String take(int n) {
    if (length <= n) return this;
    return "${substring(0, n)}...";
  }
}

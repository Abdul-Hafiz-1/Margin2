# MARGIN — Master Antigravity Implementation Prompt & Execution Blueprint

> **Repository**: [https://github.com/Abdul-Hafiz-1/Margin2](https://github.com/Abdul-Hafiz-1/Margin2)  
> **Target Framework**: Flutter (Android, Web, Desktop)  
> **Visual Identity**: Midnight Bloom (Dark-First Editorial Sanctuary)  
> **Core Principle**: *"Users should never feel like they are managing an AI system. They should feel like they are thinking, and MARGIN is helping them make progress."*

---

## 🎯 The Mission

You are tasked with turning **MARGIN** from an in-memory, custom-painted UI prototype into a **production-grade, offline-first personal journal, intelligent workspace, and creative companion**. 

You will not blindly overwrite existing files or create decorative screens that lead nowhere. You will systematically audit, refactor, and implement real infrastructure across **8 verified stages**.

---

## 🛑 Non-Negotiable Operational Rules

1. **Audit Before Mutating**: Inspect every existing file before modifying it. Understand what works, isolate mock implementations, and preserve working model relationships.
2. **Zero Fake AI**: Delete simulated `Future.delayed` and keyword string-matching. Wire genuine hybrid inference (on-device local extraction + cloud fallback via Google AI/Firebase Vertex AI Logic) using structured JSON schemas.
3. **Zero Ephemeral-Only State**: Replace in-memory `StateService` lists with a clean **Repository Pattern** backed by offline-first persistence (`hive_flutter` / SQLite / `shared_preferences`) and Firebase Firestore synchronization. Restarting the app must never wipe user thoughts or projects.
4. **Real Rive Character Runtime**: Replace the temporary Dart `CustomPainter` with the official Flutter `rive` package runtime. Margo must be driven by a real Rive state machine whose inputs (`isListening`, `isProcessing`, `progress`, `celebrate`, `mood`) react strictly to real application events.
5. **No Dead or Decorative UI**: Every button, chip, tile, and action sheet must have a defined handler, input validation, and feedback state.
6. **Fluid Editorial Responsive Shell**: Eliminate rigid hardcoded constraints (such as fixed 250px sidebars or fixed 860px max-width centers). Implement a fluid, asymmetric editorial desktop layout and a native-feeling mobile hierarchy.
7. **Zero Regressions & Clean Analysis**: Run `flutter analyze` and `flutter test` at the conclusion of every stage. Maintain 0 errors and 0 warnings.

---

## 🏗️ Technical Architecture & Dependency Specifications

Update `pubspec.yaml` with the necessary production dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1

  # Vector Mascot Animation Engine
  rive: ^0.13.1

  # Hybrid AI & Inference Engine
  google_generative_ai: ^0.4.6
  http: ^1.2.2

  # Offline-First Persistence & Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.3.2

  # Hardware Audio Dictation
  record: ^5.1.2
  path_provider: ^2.1.4

  # Firebase (Sync & Auth)
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  firebase_storage: ^12.3.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## 📋 The 8-Stage Execution Plan

Execute the transformation in the following sequential order. Do not skip stages.

```
Stage 1: Codebase Audit & Repository Architecture Setup
   │
   ▼
Stage 2: Design Tokens & Fluid Responsive Shell (Midnight Bloom)
   │
   ▼
Stage 3: Original Margo Artwork & Rive State Machine Integration
   │
   ▼
Stage 4: Redesigned Home, Journal & Thought Capture
   │
   ▼
Stage 5: Real Hybrid Inference Engine & Structured Extraction
   │
   ▼
Stage 6: Persistent Repositories, Projects, Tasks & Smart Attention
   │
   ▼
Stage 7: Team Collaboration, Shared Workspaces & Security Rules
   │
   ▼
Stage 8: Full Cross-Platform QA (Desktop, Tablet, Mobile)
```

---

### Stage 1: Codebase Audit & Repository Architecture Setup
- **Goal**: Audit existing files, identify all mock services, and create the clean abstract repository contracts.
- **Action Items**:
  1. Audit `lib/core/models/models.dart`: Validate that `JournalEntry`, `AIInsight`, `Project`, `TaskItem`, `TeamMember`, and `TeamMessage` have complete serialization (`toMap` / `fromMap` / `toJson` / `fromJson`).
  2. Create abstract repository interfaces in `lib/core/repositories/`:
     - `journal_repository.dart` (`saveEntry`, `getEntries`, `deleteEntry`, `searchEntries`, `syncOfflineQueue`)
     - `project_repository.dart` (`createProject`, `updateProject`, `getProjects`, `archiveProject`)
     - `task_repository.dart` (`createTask`, `updateTask`, `toggleTask`, `getTasksForProject`)
     - `team_repository.dart` (`sendMessage`, `getMessagesStream`, `inviteMember`)
  3. Set up `lib/core/services/storage_service.dart` with `hive_flutter` for local encrypted box initialization so that data persists across app lifecycles.

---

### Stage 2: Design Tokens & Fluid Responsive Shell
- **Goal**: Establish the genuine **Midnight Bloom** dark editorial identity and fluid layout engine.
- **Action Items**:
  1. Audit and polish `lib/theme/colors.dart`:
     - Base: Deep charcoal `#111114`, card `#1B1B21`, elevated `#25252D`, structural border `#2B2B36`.
     - Luminous Pastels: Lavender `#BCA5FF`, Soft Peach `#FFBFAF`, Mint `#A9E5CF`, Butter `#FFE599`, Sky `#B4DCFF`.
     - Warm White Typography: `#F5F3FA` (primary), `#A09BB5` (secondary), `#6C6782` (muted).
  2. Implement an adaptive layout builder in `lib/app/app.dart`:
     - **Desktop (width ≥ 1024px)**: Collapsible editorial left navigation, asymmetric two-column canvas with primary thought capture + focus workspace on the left, and attention insights + timeline on the right.
     - **Tablet (768px – 1023px)**: Slim rail navigation with adaptive project cards.
     - **Mobile (< 768px)**: Native 5-item bottom bar with elevated central capture button.
  3. Ensure zero UI render overflow errors across any window resizing.

---

### Stage 3: Original Margo Artwork & Rive State Machine Integration
- **Goal**: Replace the code-drawn CustomPainter with a production-grade **Rive** runtime character.
- **Action Items**:
  1. Declare the Rive asset in `pubspec.yaml` (`assets/rive/margo.riv`) and provide a high-fidelity vector runtime fallback for development offline builds.
  2. Implement `lib/shared/margo/margo_rive_controller.dart` managing the Rive State Machine:
     - **States**: `idle`, `listening`, `thinking`, `processing`, `idea_found`, `celebrating`, `sleeping`, `error`.
     - **Inputs**:
       - `isListening` *(SMIBool)*: Controlled by microphone capture lifecycle.
       - `isProcessing` *(SMIBool)*: Controlled by active AI model inference stream.
       - `progress` *(SMINumber 0–100)*: Real-time multistage reasoning indicator.
       - `celebrate` *(SMITrigger)*: Fired only upon milestone achievement.
  3. Refactor `lib/shared/margo/margo_widget.dart` to bind directly to `margo_rive_controller.dart`. **Crucial**: Margo must remain in the thinking/processing state while inference is running—no premature or fake success states.

---

### Stage 4: Redesigned Home, Journal & Thought Capture
- **Goal**: Create an immersive, tactile thinking experience where original thoughts are preserved as the immutable source of truth.
- **Action Items**:
  1. **Thought Capture** (`thought_capture_screen.dart`):
     - Distraction-free full-screen editor with character metrics and auto-save drafts.
     - Real audio recorder integration (`record` package) capturing actual mic input.
     - Animated audio waveform reflecting real voice volume amplitude.
     - Live transcription review step prior to saving or analyzing.
  2. **Journal Library** (`journal_screen.dart`):
     - Filter by type (`All`, `Voice`, `Analyzed`, `Projects`, `Drafts`).
     - Global full-text search across thought content and AI-discovered tags.
  3. **Saved Entry** (`saved_entry_screen.dart`):
     - Clear visual indicator showing the original thought is permanently saved.
     - Re-analyze action and linked project navigation.

---

### Stage 5: Real Hybrid Inference Engine & Structured Extraction
- **Goal**: Replace keyword simulations with an actual hybrid inference service supporting local and cloud LLM execution.
- **Action Items**:
  1. Refactor `lib/core/services/inference_service.dart`:
     - Integrate Google Generative AI (`google_generative_ai`) with structured JSON schema outputs.
     - Implement multi-stage reasoning streaming:
       1. *"Understanding your thoughts..."*
       2. *"Finding key ideas & opportunities..."*
       3. *"Connecting to existing projects..."*
       4. *"Drafting actionable next steps..."*
  2. Handle on-device vs. cloud routing:
     - **Local / On-device preference**: Extract basic key points, categorize tags, and isolate simple action items.
     - **Cloud processing (with user consent)**: Deep strategic project blueprints, timeline estimation, architecture proposals, and cross-team reasoning.
  3. Build `lib/features/intelligence/ai_insights_screen.dart`:
     - Display detected concepts and key points (every point is editable or removable by the user).
     - Selectable action plan tasks (`X of Y selected`).
     - **Mandatory User Confirmation Sheet**: Never silently create projects or tasks without explicit user approval.
  4. Ensure all generated artifacts retain bidirectional links (`sourceJournalId` <-> `projectId`).

---

### Stage 6: Persistent Repositories, Projects, Tasks & Smart Attention
- **Goal**: Complete task and project workflows with offline-first persistence.
- **Action Items**:
  1. Implement `HiveJournalRepository`, `HiveProjectRepository`, and `HiveTaskRepository`.
  2. **Smart Prioritization** (`priorities_screen.dart`):
     - Compute real attention scores based on:
       - Looming deadlines (`dueDate.difference(now)`)
       - Project momentum (`progress` velocity)
       - Overdue tasks count
     - Allow user to explicitly designate and switch the primary focus project.
  3. **Task & Project Management**:
     - Real CRUD workflows: Create, edit, complete, delete, and archive.
     - Subtasks checklist with completion progress calculations.

---

### Stage 7: Team Collaboration, Shared Workspaces & Security Rules
- **Goal**: Implement shared team workspaces, invitations, and Firebase Firestore synchronization.
- **Action Items**:
  1. Implement Firebase Authentication (Email + Google Sign-In) and multi-user data segregation.
  2. Implement `FirestoreTeamRepository` with real-time stream subscription for team discussions.
  3. Clearly distinguish Margo's AI proposals from human teammate chat bubbles in `teams_screen.dart`.
  4. Write `firestore.rules` enforcing role-based permissions (`Owner`, `Admin`, `Member`, `Viewer`).

---

### Stage 8: Full Cross-Platform QA & Verification
- **Goal**: Ensure the entire application is production-ready, performant, and responsive across all form factors.
- **Action Items**:
  1. Run `flutter analyze` and resolve all warnings, deprecations, and lint issues.
  2. Run `flutter test` and write unit/widget test suites for:
     - Repository persistence & serialization.
     - AI structured output parsing.
     - Rive mascot state machine transitions.
     - Navigation shell responsiveness.
  3. Test layout resizing on Desktop (1440px), Tablet (768px), and Mobile (375px) with zero render overflows.
  4. Build and verify release bundles:
     - `flutter build bundle`
     - `flutter build web` or desktop target.

---

## 🚦 Verification Gate Protocol

At the end of each stage, you must provide:
1. **Summary of Completed Deliverables**: Exact files created or modified.
2. **Verification Evidence**: Output of `flutter analyze` and `flutter test`.
3. **Data Flow Validation**: Confirmation that the stage adheres to real data persistence and genuine inference.
4. **Next Stage Transition**: Explicit handoff to the next numbered stage.

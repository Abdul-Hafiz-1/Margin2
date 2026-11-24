import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/state_service.dart';
import '../../core/services/inference_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../../shared/components/voice_recorder.dart';

class ThoughtCaptureScreen extends StatefulWidget {
  final JournalEntry? initialEntry;
  final bool startInVoiceMode;
  final ValueChanged<JournalEntry> onSaved;
  final ValueChanged<JournalEntry> onAnalyzeImmediately;

  const ThoughtCaptureScreen({
    super.key,
    this.initialEntry,
    this.startInVoiceMode = false,
    required this.onSaved,
    required this.onAnalyzeImmediately,
  });

  @override
  State<ThoughtCaptureScreen> createState() => _ThoughtCaptureScreenState();
}

class _ThoughtCaptureScreenState extends State<ThoughtCaptureScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _selectedProjectId;
  bool _isVoiceRecording = false;
  bool _isVoice = false;
  int _audioDurationSeconds = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialEntry?.title ?? "");
    _contentController = TextEditingController(text: widget.initialEntry?.content ?? "");
    _selectedProjectId = widget.initialEntry?.linkedProjectId;
    _isVoice = widget.initialEntry?.isVoice ?? false;
    _audioDurationSeconds = widget.initialEntry?.audioDurationSeconds ?? 0;

    if (widget.startInVoiceMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startVoiceRecording();
      });
    }
  }

  void _startVoiceRecording() {
    setState(() {
      _isVoiceRecording = true;
    });
  }

  void _handleSave({bool triggerAnalyze = false}) {
    final text = _contentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write or dictate a thought first")),
      );
      return;
    }

    final title = _titleController.text.trim().isNotEmpty
        ? _titleController.text.trim()
        : text.split("\n").first.take(32);

    final selectedProject = StateService.instance.projects
        .where((p) => p.id == _selectedProjectId)
        .firstOrNull;

    final entry = JournalEntry(
      id: widget.initialEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: text,
      originalTranscription: _isVoice ? text : widget.initialEntry?.originalTranscription,
      createdAt: widget.initialEntry?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ["Thought", if (_isVoice) "VoiceNote", if (selectedProject != null) selectedProject.category],
      linkedProjectId: _selectedProjectId,
      linkedProjectName: selectedProject?.name,
      isVoice: _isVoice,
      audioDurationSeconds: _audioDurationSeconds > 0 ? _audioDurationSeconds : 35,
      isAnalyzed: widget.initialEntry?.isAnalyzed ?? false,
    );

    if (widget.initialEntry == null) {
      StateService.instance.addJournalEntry(entry);
    } else {
      StateService.instance.updateJournalEntry(entry);
    }

    if (triggerAnalyze) {
      widget.onAnalyzeImmediately(entry);
    } else {
      widget.onSaved(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = StateService.instance.projects;
    final charCount = _contentController.text.length;

    return Scaffold(
      backgroundColor: MarginColors.cream,
      appBar: AppBar(
        title: Text(
          widget.initialEntry != null ? "Edit Thought" : "New Thought",
          style: MarginTypography.headingMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => _handleSave(triggerAnalyze: false),
            style: TextButton.styleFrom(
              backgroundColor: MarginColors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: MarginRadii.pillRadius),
            ),
            child: const Text("Save"),
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Input
                  TextField(
                    controller: _titleController,
                    style: MarginTypography.headingLarge,
                    decoration: InputDecoration(
                      hintText: "Got something on your mind?",
                      hintStyle: MarginTypography.headingLarge.copyWith(
                        color: MarginColors.textMuted,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Type, dictate or share anything...",
                    style: MarginTypography.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Project selector chip row
                  Row(
                    children: [
                      const Icon(Icons.folder_outlined, size: 16, color: MarginColors.textMuted),
                      const SizedBox(width: 8),
                      Text("Project:", style: MarginTypography.caption.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      DropdownButton<String?>(
                        value: _selectedProjectId,
                        underline: const SizedBox(),
                        hint: Text("None (Unassigned)", style: MarginTypography.caption),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text("None (Unassigned)"),
                          ),
                          ...projects.map((p) => DropdownMenuItem<String?>(
                                value: p.id,
                                child: Text(p.name),
                              )),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedProjectId = val;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Main Text Area
                  Container(
                    constraints: const BoxConstraints(minHeight: 240),
                    decoration: BoxDecoration(
                      color: MarginColors.surfaceWhite,
                      borderRadius: MarginRadii.cardRadius,
                      border: Border.all(color: MarginColors.borderLight, width: 1.2),
                      boxShadow: MarginShadows.subtle,
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _contentController,
                          maxLines: null,
                          minLines: 8,
                          onChanged: (_) => setState(() {}),
                          style: MarginTypography.bodyLarge,
                          decoration: InputDecoration(
                            hintText: "Start typing. Don't worry about organizing it...",
                            hintStyle: MarginTypography.bodyMedium.copyWith(color: MarginColors.textMuted),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_isVoice)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: MarginColors.lavenderSoft,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.mic_rounded, size: 14, color: MarginColors.purple),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Voice recorded",
                                      style: MarginTypography.caption.copyWith(
                                        color: MarginColors.purpleDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              const SizedBox(),
                            Text(
                              "$charCount / 2000",
                              style: MarginTypography.caption.copyWith(color: MarginColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bottom action buttons: Voice Dictation, Attach, Quick sample, Analyse
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: _startVoiceRecording,
                        style: IconButton.styleFrom(
                          backgroundColor: MarginColors.lavenderSoft,
                          padding: const EdgeInsets.all(14),
                        ),
                        icon: const Icon(Icons.mic_rounded, color: MarginColors.purple),
                        tooltip: "Dictate",
                      ),
                      const SizedBox(width: 10),
                      IconButton.filledTonal(
                        onPressed: () {
                          // Insert template prompt
                          setState(() {
                            if (_contentController.text.isEmpty) {
                              _titleController.text = "Starting a clothing brand";
                              _contentController.text =
                                  "I've been thinking about starting a clothing brand. Maybe minimal oversized T-shirts. I need to research manufacturers, understand the costs, create a logo, and discuss it with my friends. I don't really know where to start.";
                            }
                          });
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: MarginColors.surfaceWarm,
                          padding: const EdgeInsets.all(14),
                        ),
                        icon: const Icon(Icons.auto_fix_high_rounded, color: MarginColors.textSecondary),
                        tooltip: "Insert sample thought",
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => _handleSave(triggerAnalyze: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MarginColors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                        label: const Text("Analyse with MARGIN"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Voice Recording Modal Overlay
            if (_isVoiceRecording)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  alignment: Alignment.bottomCenter,
                  child: VoiceRecorderWidget(
                    onFinished: (transcription) {
                      setState(() {
                        _isVoiceRecording = false;
                        _isVoice = true;
                        _audioDurationSeconds = 42;
                        _contentController.text = transcription;
                        if (_titleController.text.isEmpty) {
                          _titleController.text = "Voice Memo: ${transcription.split(".").first.take(28)}";
                        }
                      });
                    },
                    onCancelled: () {
                      setState(() {
                        _isVoiceRecording = false;
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

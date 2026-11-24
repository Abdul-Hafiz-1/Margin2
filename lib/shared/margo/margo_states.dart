enum MargoMood {
  idle,
  listening,
  thinking,
  processing,
  organizing,
  ideaFound,
  excited,
  celebrating,
  sleeping,
  resting,
  error,
}

class MargoStateConfig {
  final String label;
  final String speechText;

  const MargoStateConfig({
    required this.label,
    required this.speechText,
  });

  static const Map<MargoMood, MargoStateConfig> configs = {
    MargoMood.idle: MargoStateConfig(
      label: 'Companion',
      speechText: "Make room for what matters.",
    ),
    MargoMood.listening: MargoStateConfig(
      label: 'Listening',
      speechText: "Listening closely to your voice memo...",
    ),
    MargoMood.thinking: MargoStateConfig(
      label: 'Reflecting',
      speechText: "Connecting your thoughts...",
    ),
    MargoMood.processing: MargoStateConfig(
      label: 'Synthesizing',
      speechText: "Extracting actionable structure...",
    ),
    MargoMood.organizing: MargoStateConfig(
      label: 'Structuring',
      speechText: "Structuring your thoughts into clear plans...",
    ),
    MargoMood.ideaFound: MargoStateConfig(
      label: 'Idea Found',
      speechText: "Here's what I found in your notes!",
    ),
    MargoMood.excited: MargoStateConfig(
      label: 'Inspired',
      speechText: "Ooh! There's an exciting idea here!",
    ),
    MargoMood.celebrating: MargoStateConfig(
      label: 'Delighted',
      speechText: "Milestone achieved! Momentum unlocked.",
    ),
    MargoMood.sleeping: MargoStateConfig(
      label: 'Quiet Space',
      speechText: "Quiet moments. Ready whenever you are.",
    ),
    MargoMood.resting: MargoStateConfig(
      label: 'Resting',
      speechText: "Take your time. A fresh space awaits.",
    ),
    MargoMood.error: MargoStateConfig(
      label: 'Puzzled',
      speechText: "Could you tell me a little more?",
    ),
  };
}

enum AICellType {
  my,
  bot
}

class AIModel {
  final AICellType type;
  final String text;
  bool isPlaying = false;
  bool notRead = true;

  AIModel(this.text, this.type);
}
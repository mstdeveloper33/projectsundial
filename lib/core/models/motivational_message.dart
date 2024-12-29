class MotivationalMessage {
  final String message;

  MotivationalMessage({required this.message});

  // JSON'dan Model'e dönüştürme
  factory MotivationalMessage.fromJson(Map<String, dynamic> json) {
    return MotivationalMessage(
      message: json['message'],
    );
  }
}

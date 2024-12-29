import 'dart:convert';
import '../models/motivational_message.dart';

class ApiService {
  // Motivational Message API Simülasyonu
  Future<MotivationalMessage> fetchMotivationalMessage() async {
    const jsonString = '{"message": "You\'re doing great! Keep it up!"}';
    final data = jsonDecode(jsonString);
    return MotivationalMessage.fromJson(data);
  }

}

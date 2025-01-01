import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/health_metrics_model.dart';
import '../models/motivational_message.dart';

class ApiService {
  Future<List<HealthMetrics>> fetchHealthMetrics() async {
  try {
    final String response = await rootBundle.loadString('lib/assets/modeljson/wearable_data.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => HealthMetrics.fromJson(json)).toList();
  } catch (e) {
    // Hata durumunda bir mesaj göster
    throw Exception("Veri yüklenirken bir hata oluştu: $e");
  }
}

  Future<List<MotivationalMessage>> fetchMotivationalMessages() async {
   try {
      final String response = await rootBundle.loadString('lib/assets/modeljson/motivational_messages.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => MotivationalMessage.fromJson(json)).toList();
   } catch (e) {
     throw Exception("Veri yüklenirken bir hata oluştu: $e");
   }
  }
}
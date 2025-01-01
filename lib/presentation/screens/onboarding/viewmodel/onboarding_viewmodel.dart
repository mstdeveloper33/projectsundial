import 'package:flutter/material.dart';

import '../../../../core/dependencies/locator.dart';
import '../../../../core/models/motivational_message.dart';
import '../../../../core/services/api_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  final _apiService = locator<ApiService>();

  List<MotivationalMessage>? motivationalMessages;

  Future<void> loadMotivationalMessage() async {
    motivationalMessages = await _apiService.fetchMotivationalMessages();
    notifyListeners();
  }
}
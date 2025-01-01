import 'package:flutter/material.dart';
import 'package:sundialproject/core/services/sqlite_service.dart';
import 'package:sundialproject/core/models/journal_entry_model.dart';

import '../../../../core/dependencies/locator.dart';
import '../../../../core/models/health_metrics_model.dart';
import '../../../../core/models/motivational_message.dart';
import '../../../../core/services/api_service.dart';

class JournalingViewModel extends ChangeNotifier {
  final ApiService _apiService = locator<ApiService>();
  final SQLiteService _sqliteService;
  List<HealthMetrics> healthMetrics = [];
  List<MotivationalMessage> motivationalMessages = [];
  JournalingViewModel(this._sqliteService) {
    loadEntries(); // Uygulama başlatıldığında verileri yükle
  }
  String journalText = '';
  String selectedMood = "😊"; // Default mood
  List<JournalEntry> journalEntries = [];
  JournalEntry? editingEntry;

  Future<void> fetchHealthMetrics() async {
    try {
      healthMetrics = await _apiService.fetchHealthMetrics();
      notifyListeners(); // UI'yı güncelle
    } catch (e) {
      healthMetrics = [];
      notifyListeners(); // Hata durumunda UI'yı güncelle
    }
  }

  Future<void> fetchMotivationalMessages() async {
    try {
      motivationalMessages = await _apiService.fetchMotivationalMessages();
      notifyListeners(); // UI'yı güncelle
    } catch (e) {
      motivationalMessages = [];
      notifyListeners(); // Hata durumunda UI'yı güncelle
    }
  }


 


  void updateJournalText(String text) {
    journalText = text;
    notifyListeners();
  }

  void updateMood(String mood) {
    selectedMood = mood;
    notifyListeners();
  }

  // Düzenleme modunu iptal et
  void cancelEditing() {
    editingEntry = null;
    journalText = '';
    selectedMood = "😊";
    notifyListeners();
  }

  Future<void> saveEntry() async {
    final entryDate = DateTime.now();
    final entry = JournalEntry(
      id: editingEntry?.id,
      text: journalText,
      mood: selectedMood,
      date: entryDate.toIso8601String(),
    );
    await _sqliteService.saveJournalEntry(entry);
    journalText = '';
    selectedMood = "😊";
    editingEntry = null;
    await loadEntries();
  }

  Future<void> loadEntries() async {
    journalEntries = await _sqliteService.getJournalEntries();
    journalEntries = journalEntries.reversed.toList(); // Listeyi ters çevir
    notifyListeners();
  }

  Future<void> deleteEntry(int id) async {
    await _sqliteService.deleteJournalEntry(id);
    await loadEntries();
  }

  void editEntry(JournalEntry entry) {
    journalText = entry.text;
    selectedMood = entry.mood;
    editingEntry = entry;
    notifyListeners();
  }

 Map<String, Map<int, int>> getMoodCountsForCurrentWeek() {
  Map<String, Map<int, int>> moodCounts = {
    "😊": {},
    "😞": {},
    "😠": {},
  };

  final now = DateTime.now();
  final endDate = now;
  final startDate = now.subtract(Duration(days: 6)); // Son 7 günü kapsayacak şekilde

  for (var entry in journalEntries) {
    DateTime entryDate = DateTime.parse(entry.date);
    // Tarihi gün başına normalize et
    entryDate = DateTime(entryDate.year, entryDate.month, entryDate.day);
    
    if (entryDate.isAfter(startDate.subtract(Duration(days: 1))) &&
        entryDate.isBefore(endDate.add(Duration(days: 1)))) {
      // Günün indeksini hesapla (0-6 arası)
      int dayIndex = entryDate.difference(startDate).inDays + 1;
      moodCounts[entry.mood]?[dayIndex] =
          (moodCounts[entry.mood]?[dayIndex] ?? 0) + 1;
    }
  }

  // Eksik günler için 0 değeri ata
  for (int i = 1; i <= 7; i++) {
    moodCounts.forEach((mood, counts) {
      counts.putIfAbsent(i, () => 0);
    });
  }

  return moodCounts;
}
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sundialproject/core/services/api_service.dart';
import 'package:sundialproject/core/models/health_metrics_model.dart';
import 'package:sundialproject/core/models/motivational_message.dart';
import 'package:sundialproject/presentation/screens/journaling/viewmodel/journal_viewmodel.dart';

import '../../../../core/dependencies/locator.dart';

class JournalingView extends StatefulWidget {
  const JournalingView({super.key});

  @override
  _JournalingViewState createState() => _JournalingViewState();
}

class _JournalingViewState extends State<JournalingView> {
  late TextEditingController _textController;
  List<HealthMetrics> healthMetrics = [];
  List<MotivationalMessage> motivationalMessages = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    fetchHealthMetrics();
    fetchMotivationalMessages();
    getCurrentDayHealthMetrics();
    getCurrentDayMotivationalMessage();
  }

  HealthMetrics? getCurrentDayHealthMetrics() {
    final now = DateTime.now();
    return healthMetrics.firstWhere(
      (metric) => _isSameDay(metric.lastUpdated, now),
      orElse: () => HealthMetrics(
        steps: 0,
        heartRate: 0,
        lastUpdated: now,
      ),
    );
  }

  MotivationalMessage? getCurrentDayMotivationalMessage() {
    final now = DateTime.now();
    return motivationalMessages.firstWhere(
      (message) => _isSameDay(message.date, now),
      orElse: () => MotivationalMessage(
        message: "Make today count!",
        date: now,
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> fetchHealthMetrics() async {
    try {
      final apiService = locator<ApiService>();
      final metricsList = await apiService.fetchHealthMetrics();
      setState(() {
        healthMetrics = metricsList;
      });
    } catch (e) {
      setState(() {
        healthMetrics = [];
      });
    }
  }

  Future<void> fetchMotivationalMessages() async {
    try {
      final apiService = locator<ApiService>();
      final messagesList = await apiService.fetchMotivationalMessages();
      setState(() {
        motivationalMessages = messagesList;
      });
    } catch (e) {
      setState(() {
        motivationalMessages = [];
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<JournalingViewModel>(
      builder: (context, viewModel, child) {
        _textController.text = viewModel.journalText;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            viewModel.cancelEditing();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("My Diary"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.dashboard), // Dashboard simgesi
                  onPressed: () {
                    context.go('/dashboard'); // Dashboard'a yönlendirme
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _textController,
                    onChanged: (value) {
                      viewModel.updateJournalText(value);
                    },
                    decoration: const InputDecoration(
                      labelText: "Write your journal entry",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    maxLength: 2000,
                  ),
                  SizedBox(height: size.height * 0.02),
                  const Text("Select your mood:"),
                  Row(
                    children: [
                      _buildMoodOption(viewModel, "😊"),
                      _buildMoodOption(viewModel, "😞"),
                      _buildMoodOption(viewModel, "😠"),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 92, 135, 149)),
                        onPressed: viewModel.journalText.isEmpty
                            ? null
                            : () async {
                                await viewModel.saveEntry();
                                _textController.clear();
                              },
                        child: Text(
                          viewModel.editingEntry == null
                              ? "Save Entry"
                              : "Update Entry",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.005,
                          horizontal: size.width * 0.1,
                        ),
                        child: Text(
                          "Your Diarys",
                          style: TextStyle(fontSize: size.width * 0.04),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.journalEntries.length,
                      itemBuilder: (context, index) {
                        final entry = viewModel.journalEntries[index];
                        final date = DateTime.parse(entry.date);
                        DateFormat('MMM dd yyyy').format(date);
                        final formattedTime =
                            DateFormat('hh:mm a').format(date);

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.005),
                          child: Card(
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.15,
                                  height: size.height * 0.1,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      DateFormat('MMM\ndd\nyyyy')
                                          .format(date)
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.03,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.mood,
                                        style: TextStyle(
                                            fontSize: size.width * 0.05),
                                      ),
                                      Text(
                                        entry.text,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: size.width * 0.04),
                                      ),
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.width * 0.03),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    viewModel.editEntry(entry);
                                    _textController.text = entry.text;
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () async {
                                    await viewModel.deleteEntry(entry.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  // Sağlık Metrikleri ve Motivasyon Mesajı Kartları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHealthCard(
                        size,
                        "lib/assets/healt/step.png",
                        getCurrentDayHealthMetrics()?.steps.toString() ?? "0",
                      ),
                      SizedBox(width: size.width * 0.02),
                      _buildHealthCard(
                        size,
                        "lib/assets/healt/heart.png",
                        "${getCurrentDayHealthMetrics()?.heartRate ?? 0} bpm",
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  if (motivationalMessages.isNotEmpty)
                    Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getCurrentDayMotivationalMessage()?.message ??
                                "Make today amazing!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: size.width * 0.04),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodOption(JournalingViewModel viewModel, String mood) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => viewModel.updateMood(mood),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        padding: EdgeInsets.all(size.width * 0.01),
        decoration: BoxDecoration(
          border: Border.all(
            color: viewModel.selectedMood == mood
                ? Colors.blue
                : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          mood,
          style: TextStyle(
            fontSize: size.width * 0.05,
            color: viewModel.selectedMood == mood ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard(Size size, String assetPath, String data) {
    return Card(
      color: const Color.fromARGB(255, 92, 135, 149),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Row(
          children: [
            Image.asset(assetPath, height: size.height * 0.03),
            SizedBox(width: size.width * 0.02),
            Text(
              data,
              style:
                  TextStyle(color: Colors.white, fontSize: size.width * 0.05),
            ),
          ],
        ),
      ),
    );
  }
}

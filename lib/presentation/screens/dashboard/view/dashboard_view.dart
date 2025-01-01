import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../journaling/viewmodel/journal_viewmodel.dart';
import 'dashboard_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<JournalingViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dashboard"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Geri butonu
          onPressed: () {
            context.go('/journal'); // JournalingView'e yönlendirme
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMoodLegend(context), // Emoji ve çizgi gösterge kartları
            Expanded(
              child: MoodLineChart(
                  viewModel: viewModel), // MoodLineChart widget'ını kullanın
            ),
            const SizedBox(height: 10),
            _buildHighlightCard(viewModel),
            const SizedBox(height: 10),
            Text(
                "Total Steps: ${viewModel.healthMetrics.isNotEmpty ? viewModel.healthMetrics.first.steps : 0}"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard(JournalingViewModel viewModel) {
    if (viewModel.journalEntries.isEmpty) {
      return const Card(
        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No mood entries available.",
              style: TextStyle(color: Colors.white)),
        ),
      );
    }

    // En olumlu ruh hali girişini bul
    final bestEntry =
        viewModel.journalEntries.where((entry) => entry.mood == "😊").isNotEmpty
            ? viewModel.journalEntries
                .where((entry) => entry.mood == "😊")
                .reduce((a, b) => a.date.compareTo(b.date) > 0 ? a : b)
            : viewModel.journalEntries.first;

    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Best Mood Entry",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text(bestEntry.text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // Emoji ve çizgi gösterge kartları
  Widget _buildMoodLegend(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalMargin = screenWidth * 0.3;
    double verticalMargin =
        screenHeight * 0.001; // %5 margin, ekran genişliğine göre ayarlandı
    return Align(
      alignment: Alignment.center, // Ortalamak için
      child: Card(
        margin: EdgeInsets.symmetric(
            vertical: verticalMargin,
            horizontal:
                horizontalMargin), // Kartın kenar boşluklarını ayarlayarak genişliğini küçültüyoruz
        child: Container(
          width: double.infinity, // Kartın içeriğine göre genişliği doldur
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Başlıkların sola yaslanması için
            children: [
              _buildMoodIndicator("😊",
                  const LinearGradient(colors: [Colors.lime, Colors.green])),
              _buildMoodIndicator(
                  "😞",
                  const LinearGradient(
                      colors: [Colors.lightBlue, Colors.blue])),
              _buildMoodIndicator("😠",
                  const LinearGradient(colors: [Colors.redAccent, Colors.red])),
            ],
          ),
        ),
      ),
    );
  }

  // Tek bir emoji ve çizgi gösterge kartı
  _buildMoodIndicator(String mood, Gradient gradient) {
    return Row(
      children: [
        Text(
          mood,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(width: 20),
        Container(
          height: 3,
          width: 50, // Çizginin genişliği
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

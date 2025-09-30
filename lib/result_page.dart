import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'components.dart';
import 'models.dart';
import 'quiz_page.dart';

class ResultPage extends StatelessWidget {
  final TestResult result;
  const ResultPage({required this.result, super.key});

  String interpret() {
    final pct = result.score / result.maxScore;
    if (pct >= 0.8) return 'Very compatible — keep nurturing this relationship.';
    if (pct >= 0.6) return 'Generally compatible — some areas to watch.';
    if (pct >= 0.4) return 'Mixed signals — consider talking openly.';
    return 'Potential conflicts — consider mediation or clearer boundaries.';
  }

  List<int> getWeakAreas() {
    List<int> weak = [];
    for (int i = 0; i < result.answers.length; i++) {
      if (result.answers[i] < 2) {
        weak.add(i);
      }
    }
    return weak;
  }

  @override
  Widget build(BuildContext context) {
    final pct = result.score / result.maxScore;
    final weakAreas = getWeakAreas();

    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Result'),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Result for ${result.partnerName}', style: Theme.of(context).textTheme.headlineMedium),
                                const SizedBox(height: 16),
                                Center(
                                  child: CircularPercentIndicator(
                                    radius: 80.0,
                                    lineWidth: 12.0,
                                    percent: pct,
                                    center: Text('${(pct * 100).round()}%', style: Theme.of(context).textTheme.headlineMedium),
                                    progressColor: Theme.of(context).colorScheme.primary,
                                    backgroundColor: Theme.of(context).colorScheme.background,
                                    animation: true,
                                    animationDuration: 1000,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text('Score: ${result.score} / ${result.maxScore}', style: Theme.of(context).textTheme.bodyLarge),
                                const SizedBox(height: 12),
                                Text(interpret(), style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Weak Areas', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                if (weakAreas.isEmpty)
                                  Text('None identified.', style: Theme.of(context).textTheme.bodyMedium)
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: weakAreas.length,
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(Icons.warning_amber, color: Theme.of(context).colorScheme.error),
                                        title: Text(defaultQuestions[weakAreas[i]].text, style: Theme.of(context).textTheme.bodyMedium),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedButton(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.home),
                            label: const Text('Return Home'),
                            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
                            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
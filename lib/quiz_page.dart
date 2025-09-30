import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'components.dart';
import 'models.dart';
import 'result_page.dart';
import 'storage.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  final _answers = <int>[];
  int _current = 0;
  List<Question> questions = defaultQuestions;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _answers.addAll(List.filled(questions.length, -1));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < questions.length - 1) {
      setState(() {
        _current++;
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_current > 0) {
      setState(() {
        _current--;
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  Future<void> _finish() async {
    int score = 0;
    int maxScore = questions.length * 4;
    final processedAnswers = _answers.map((a) => a < 0 ? 2 : a).toList();
    for (int i = 0; i < questions.length; i++) {
      score += processedAnswers[i] * questions[i].weight;
    }

    final profile = await LocalStorage.loadProfile();
    final partnerName = profile?['partnerName'] ?? 'Partner';

    final result = TestResult(
      id: const Uuid().v4(),
      partnerName: partnerName,
      date: DateTime.now(),
      score: score,
      maxScore: maxScore,
      answers: processedAnswers,
    );

    await LocalStorage.addResult(result);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultPage(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[_current];
    final options = ['Strongly disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly agree'];

    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text('Test — ${_current + 1}/${questions.length}'),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: (_current + 1) / questions.length,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              q.text,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: options.length,
                            itemBuilder: (context, i) {
                              return Card(
                                color: _answers[_current] == i ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : null,
                                child: RadioListTile<int>(
                                  value: i,
                                  groupValue: _answers[_current] >= 0 ? _answers[_current] : null,
                                  title: Text(options[i], style: Theme.of(context).textTheme.bodyLarge),
                                  activeColor: Theme.of(context).colorScheme.primary,
                                  onChanged: (v) {
                                    setState(() {
                                      _answers[_current] = v ?? 2;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_current > 0)
                              AnimatedButton(
                                child: OutlinedButton.icon(
                                  onPressed: _prev,
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Previous'),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                    minimumSize: const Size(150, 50),
                                  ),
                                ),
                              )
                            else
                              const SizedBox(),
                            AnimatedButton(
                              child: ElevatedButton.icon(
                                onPressed: _answers[_current] < 0 ? null : _next,
                                icon: Icon(_current == questions.length - 1 ? Icons.check : Icons.arrow_forward),
                                label: Text(_current == questions.length - 1 ? 'Finish' : 'Next'),
                                style: ElevatedButton.styleFrom(minimumSize: const Size(150, 50)),
                              ),
                            ),
                          ],
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

final List<Question> defaultQuestions = [
  Question(text: 'Do they show respect for your boundaries?'),
  Question(text: 'Do they try to understand your perspective?'),
  Question(text: 'Are they supportive of your relationship decisions?'),
  Question(text: 'Do they communicate clearly and calmly?'),
  Question(text: 'Do they avoid gossip or unnecessary criticism?'),
  Question(text: 'Are they willing to help when needed?'),
  Question(text: 'Do they make an effort to know you as a person?'),
  Question(text: 'Do they respect your partner’s privacy?'),
  Question(text: 'Are cultural or value differences handled respectfully?'),
  Question(text: 'Do they show appreciation or gratitude?'),
];
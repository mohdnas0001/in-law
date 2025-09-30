import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components.dart';
import 'models.dart';
import 'result_page.dart';
import 'storage.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<TestResult> _results = [];
  final _key = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await LocalStorage.loadResults();
    setState(() => _results = r);
  }

  Future<void> _clear() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all test results?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Clear', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await LocalStorage.clearHistory();
      final oldResults = _results;
      setState(() => _results = []);
      for (var i = 0; i < oldResults.length; i++) {
        _key.currentState?.removeItem(0, (context, animation) => _buildItem(oldResults[i], animation));
      }
    }
  }

  Future<void> _deleteResult(String id) async {
    final index = _results.indexWhere((r) => r.id == id);
    if (index >= 0) {
      final removed = _results.removeAt(index);
      await LocalStorage.deleteResult(id);
      _key.currentState?.removeItem(
        index,
        (context, animation) => _buildItem(removed, animation),
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  Widget _buildItem(TestResult r, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text('${r.partnerName} — ${r.score}/${r.maxScore}', style: Theme.of(context).textTheme.bodyLarge),
          subtitle: Text(r.date.toLocal().toString().split('.')[0], style: Theme.of(context).textTheme.bodyMedium),
          trailing: IconButton(
            icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
            onPressed: () => _deleteResult(r.id),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ResultPage(result: r)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Test History'),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _results.isEmpty
                      ? Center(child: Text('No results yet — take a test.', style: Theme.of(context).textTheme.bodyLarge))
                      : AnimatedList(
                          key: _key,
                          initialItemCount: _results.length,
                          itemBuilder: (context, index, animation) => _buildItem(_results[index], animation),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedButton(
                      child: ElevatedButton.icon(
                        onPressed: _clear,
                        icon: const Icon(Icons.delete),
                        label: const Text('Clear History'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          minimumSize: const Size(150, 50),
                        ),
                      ),
                    ),
                    AnimatedButton(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
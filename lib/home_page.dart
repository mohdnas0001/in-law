import 'package:flutter/material.dart';
import 'components.dart';
import 'storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String partnerName = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await LocalStorage.loadProfile();
    setState(() {
      userName = p?['userName'] ?? '';
      partnerName = p?['partnerName'] ?? '';
    });
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (_) => const CustomAboutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('In-law Compatibility'),
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: _showAbout,
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Welcome${userName.isNotEmpty ? ', $userName' : ''}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Partner/In-law: ${partnerName.isNotEmpty ? partnerName : 'Not set'}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AnimatedButton(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.quiz),
                              label: const Text('Take Compatibility Test'),
                              onPressed: () => Navigator.pushNamed(context, '/quiz'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          AnimatedButton(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.person),
                              label: const Text('Profile & Preferences'),
                              onPressed: () => Navigator.pushNamed(context, '/profile'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quick Tips', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('• Be honest when taking the test.'),
                          const Text('• This test is for reflection, not a diagnosis.'),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.history, color: Colors.black),
        onPressed: () => Navigator.pushNamed(context, '/history'),
      ),
    );
  }
}
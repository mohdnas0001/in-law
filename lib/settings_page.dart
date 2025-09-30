import 'package:flutter/material.dart';
import 'components.dart';
import 'storage.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _confirmOnExit = true;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await LocalStorage.loadThemeMode();
    setState(() => _themeMode = mode);
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    await LocalStorage.saveThemeMode(mode);
    themeNotifier.value = mode;
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
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Settings'),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text('Confirm before clearing history', style: Theme.of(context).textTheme.bodyLarge),
                              value: _confirmOnExit,
                              onChanged: (v) => setState(() => _confirmOnExit = v),
                              activeColor: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            ListTile(
                              title: Text('Theme', style: Theme.of(context).textTheme.bodyLarge),
                              trailing: DropdownButton<ThemeMode>(
                                value: _themeMode,
                                items: const [
                                  DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                                  DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                                ],
                                onChanged: (mode) {
                                  if (mode != null) _saveTheme(mode);
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            ListTile(
                              leading: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary),
                              title: Text('About this app', style: Theme.of(context).textTheme.bodyLarge),
                              onTap: _showAbout,
                            ),
                          ],
                        ),
                      ),
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
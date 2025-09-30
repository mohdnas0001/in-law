import 'package:flutter/material.dart';
import 'components.dart';
import 'storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _form = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _partnerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await LocalStorage.loadProfile();
    setState(() {
      _userController.text = p?['userName'] ?? '';
      _partnerController.text = p?['partnerName'] ?? '';
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    await LocalStorage.saveProfile({
      'userName': _userController.text.trim(),
      'partnerName': _partnerController.text.trim(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Profile saved'), backgroundColor: Theme.of(context).colorScheme.primary),
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
                title: const Text('Profile & Preferences'),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _userController,
                                decoration: const InputDecoration(
                                  labelText: 'Your name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Enter your name' : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _partnerController,
                                decoration: const InputDecoration(
                                  labelText: 'Partner / In-law name',
                                  prefixIcon: Icon(Icons.group),
                                ),
                              ),
                              const SizedBox(height: 16),
                              AnimatedButton(
                                child: ElevatedButton(
                                  onPressed: _save,
                                  child: const Text('Save'),
                                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                                ),
                              ),
                            ],
                          ),
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
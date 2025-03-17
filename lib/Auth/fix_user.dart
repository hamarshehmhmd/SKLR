import 'package:flutter/material.dart';
import '../database/supabase_service.dart';
import '../Home/home.dart';

class FixUserPage extends StatefulWidget {
  const FixUserPage({super.key});

  @override
  _FixUserPageState createState() => _FixUserPageState();
}

class _FixUserPageState extends State<FixUserPage> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _usersNeedingFix = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await SupabaseService.getUsersNeedingAuthFix();
      setState(() {
        _usersNeedingFix = users;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading users: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fixUser(String email) async {
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a new password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await SupabaseService.fixExistingUser(
        email,
        _passwordController.text,
      );

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User fixed successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fix User Authentication'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Users Needing Authentication Fix',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'New Password for User',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _usersNeedingFix.length,
                      itemBuilder: (context, index) {
                        final user = _usersNeedingFix[index];
                        return Card(
                          child: ListTile(
                            title: Text(user['username'] ?? 'Unknown'),
                            subtitle: Text(user['email'] ?? 'No email'),
                            trailing: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _fixUser(user['email']),
                              child: const Text('Fix User'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
} 
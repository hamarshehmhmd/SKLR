import 'package:flutter/material.dart';
import '../database/supabase_service.dart';
import '../database/database.dart';
import '../Home/home.dart';

class TestAuthPage extends StatelessWidget {
  const TestAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final response = await SupabaseService.createTestUser();
                if (response.success) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Test user logged in: ${response.message}')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${response.message}')),
                    );
                  }
                }
              },
              child: const Text('Create/Login Test User'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Test User Credentials:\nEmail: test@example.com\nPassword: Test123!\nUsername: testuser',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';

void chose_language() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LanguageSelectionScreen(),
    );
  }
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = "English (UK)";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;
    final horizontalPadding = isLargeScreen ? 32.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Language",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 8,
        ),
        children: [
          // Suggested Section
          const Text(
            "Suggested",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          RadioListTile<String>(
            title: const Text("English (US)"),
            value: "English (US)",
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text("English (UK)"),
            value: "English (UK)",
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
              });
            },
          ),
          const Divider(thickness: 1, color: Colors.grey),

          // Others Section
          const Text(
            "Others",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          ..._buildLanguageOptions([
            "Mandarin",
            "Hindi",
            "Spanish",
            "French",
            "Arabic",
            "Russian",
            "Indonesia",
            "Vietnamese",
          ]),
        ],
      ),
    );
  }

  // Helper to build language options
  List<Widget> _buildLanguageOptions(List<String> languages) {
    return languages
        .map(
          (language) => RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
              });
            },
          ),
        )
        .toList();
  }
}
// responsive check done 
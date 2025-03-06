import 'package:flutter/material.dart';

void Notification() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationSettingsScreen(),
    );
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // State for individual toggles
  bool generalNotification = true;
  bool sound = false;
  bool vibrate = true;
  bool appUpdates = false;
  bool billReminder = true;
  bool promotion = true;
  bool discountAvailable = true;
  bool paymentRequest = false;
  bool newServiceAvailable = false;
  bool newTipsAvailable = true;

  // State for section master toggles
  bool commonMasterToggle = true;
  bool systemServicesMasterToggle = false;
  bool othersMasterToggle = false;

  // Function to toggle all switches in a section
  void toggleCommonSection(bool value) {
    setState(() {
      commonMasterToggle = value;
      generalNotification = value;
      sound = value;
      vibrate = value;
    });
  }

  void toggleSystemServicesSection(bool value) {
    setState(() {
      systemServicesMasterToggle = value;
      appUpdates = value;
      billReminder = value;
      promotion = value;
      discountAvailable = value;
      paymentRequest = value;
    });
  }

  void toggleOthersSection(bool value) {
    setState(() {
      othersMasterToggle = value;
      newServiceAvailable = value;
      newTipsAvailable = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Common Section
          SectionHeader(
            title: "Common",
            masterToggleValue: commonMasterToggle,
            onMasterToggleChanged: toggleCommonSection,
          ),
          SwitchTile(
            title: "General Notification",
            value: generalNotification,
            onChanged: (value) {
              setState(() {
                generalNotification = value;
              });
            },
          ),
          SwitchTile(
            title: "Sound",
            value: sound,
            onChanged: (value) {
              setState(() {
                sound = value;
              });
            },
          ),
          SwitchTile(
            title: "Vibrate",
            value: vibrate,
            onChanged: (value) {
              setState(() {
                vibrate = value;
              });
            },
          ),
          Divider(thickness: 1, color: Colors.grey[300]),

          // System & Services Update Section
          SectionHeader(
            title: "System & services update",
            masterToggleValue: systemServicesMasterToggle,
            onMasterToggleChanged: toggleSystemServicesSection,
          ),
          SwitchTile(
            title: "App updates",
            value: appUpdates,
            onChanged: (value) {
              setState(() {
                appUpdates = value;
              });
            },
          ),
          SwitchTile(
            title: "Bill Reminder",
            value: billReminder,
            onChanged: (value) {
              setState(() {
                billReminder = value;
              });
            },
          ),
          SwitchTile(
            title: "Promotion",
            value: promotion,
            onChanged: (value) {
              setState(() {
                promotion = value;
              });
            },
          ),
          SwitchTile(
            title: "Discount Available",
            value: discountAvailable,
            onChanged: (value) {
              setState(() {
                discountAvailable = value;
              });
            },
          ),
          SwitchTile(
            title: "Payment Request",
            value: paymentRequest,
            onChanged: (value) {
              setState(() {
                paymentRequest = value;
              });
            },
          ),
          Divider(thickness: 1, color: Colors.grey[300]),

          // Others Section
          SectionHeader(
            title: "Others",
            masterToggleValue: othersMasterToggle,
            onMasterToggleChanged: toggleOthersSection,
          ),
          SwitchTile(
            title: "New Service Available",
            value: newServiceAvailable,
            onChanged: (value) {
              setState(() {
                newServiceAvailable = value;
              });
            },
          ),
          SwitchTile(
            title: "New Tips Available",
            value: newTipsAvailable,
            onChanged: (value) {
              setState(() {
                newTipsAvailable = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final bool masterToggleValue;
  final ValueChanged<bool> onMasterToggleChanged;

  const SectionHeader({super.key, 
    required this.title,
    required this.masterToggleValue,
    required this.onMasterToggleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Switch(
            value: masterToggleValue,
            onChanged: onMasterToggleChanged,
            activeColor: Color(0xFF6296FF),
          ),
        ],
      ),
    );
  }
}

class SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({super.key, 
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor:  Color(0xFF6296FF),
          ),
        ],
      ),
    );
  }
}

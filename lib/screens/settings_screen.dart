import 'package:flutter/material.dart';
// import 'package:wordwizz/models/settings_model.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'Polski';
  double _fontSize = 16.0;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Przełącznik motywu
            ListTile(
              title: const Text('Tryb ciemny'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
            ),

            // Zmiana języka
            ListTile(
              title: const  Text('Język'),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                items: <String>['Polski', 'English', 'Español']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            // Zmiana rozmiaru czcionki
            ListTile(
              title: const  Text('Rozmiar czcionki'),
              subtitle: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _fontSize = 14.0;
                      });
                    },
                    child: const Text('Mała'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _fontSize = 16.0;
                      });
                    },
                     child: const Text('Średnia'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _fontSize = 18.0;
                      });
                    },
                    child: const Text('Duża'),
                  ),
                ],
              ),
            ),

            // Włączenie/wyłączenie powiadomień
            ListTile(
              title: const Text('Powiadomienia'),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),

            // Można dodać więcej ustawień, jeśli potrzebne
          ],
        ),
      ),
    );
  }
}
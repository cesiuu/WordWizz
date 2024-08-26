
import 'package:flutter/material.dart';
import 'package:wordwizz/models/links_model.dart';

class CourseListScreen extends StatelessWidget {
  CourseListScreen({super.key});
  final List<Course> courses = [
    Course(
      title: 'Flutter dla początkujących (A1)',
      description: 'Podstawy Fluttera, instalacja, pierwsza aplikacja.',
      grammar: 'Wprowadzenie do języka Dart, podstawy składni.',
      youtubeLink: 'https://www.youtube.com/watch?v=ijJ6b0hZNKE',
    ),
    Course(
      title: 'Flutter średniozaawansowany (B1)',
      description: 'State management, budowanie interfejsu użytkownika.',
      grammar: 'Zaawansowane typy danych, zarządzanie stanem aplikacji.',
      youtubeLink: 'https://www.youtube.com/watch?v=ijJ6b0hZNKE',
    ),
    Course(
      title: 'Flutter zaawansowany (C1)',
      description: 'Integracja z API, zarządzanie danymi, animacje.',
      grammar: 'Async/await, obsługa strumieni, animacje.',
      youtubeLink: 'https://www.youtube.com/watch?v=ijJ6b0hZNKE',
    ),
    // tutaj mozesz dodac wiecej kursów 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kursy Flutter'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(courses[index].title),
            subtitle: Text(courses[index].description),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(course: courses[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  CourseDetailScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Opis kursu:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(course.description),
           const  SizedBox(height: 16),
           const  Text(
              'Gramatyka:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(course.grammar),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                
              },
              child: const Text('Przejdź do kursu na YouTube'),
            ),
          ],
        ),
      ),
    );
  }
}



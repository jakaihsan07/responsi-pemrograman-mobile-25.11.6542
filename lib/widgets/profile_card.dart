import 'package:flutter/material.dart';
import '../models/student.dart';

class ProfileCard extends StatelessWidget {
  final Student student;
  const ProfileCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(radius: 40, child: Text(student.name[0].toUpperCase(), style: const TextStyle(fontSize: 32))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(student.nim, style: const TextStyle(color: Colors.grey)),
                  Text(student.programStudi, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
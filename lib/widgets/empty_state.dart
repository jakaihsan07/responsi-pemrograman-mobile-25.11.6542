import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Belum ada catatan kuliah', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
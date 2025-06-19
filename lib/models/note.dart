import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String description;
  bool checked;
  Color color;

  // Constructor
  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.checked,
    required this.color,
  });

  // From Firestore to Note
  factory Note.fromMap(Map<String, dynamic> data, String docId) {
    return Note(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      checked: data['checked'] ?? false, // Add this for checked field
      color: Color(data['color']), // Assuming the color is stored as an integer
    );
  }

  // To Firestore format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'checked': checked,
      'color': color.value, // Storing the color as integer (ARGB)
    };
  }
}

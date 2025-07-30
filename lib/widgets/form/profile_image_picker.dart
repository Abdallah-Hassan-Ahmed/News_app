import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ProfileImagePicker({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocal = imagePath != null && imagePath!.isNotEmpty;
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.deepPurple.shade100,
          backgroundImage: isLocal ? FileImage(File(imagePath!)) : null,
          child: isLocal
              ? null
              : const Icon(Icons.camera_alt, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}

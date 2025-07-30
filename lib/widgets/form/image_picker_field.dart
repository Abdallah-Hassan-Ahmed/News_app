import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatelessWidget {
  final File? image;
  final ValueChanged<File> onImageSelected;

  const ImagePickerField({
    super.key,
    required this.image,
    required this.onImageSelected,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onImageSelected(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Profile Image", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickImage(context),
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(image!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

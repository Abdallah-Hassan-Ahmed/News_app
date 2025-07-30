import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatelessWidget {
  final DateTime? initialDate;
  final void Function(DateTime) onDateSelected;
  final String label;

  const DatePickerFormField({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: initialDate != null
          ? DateFormat('yyyy-MM-dd').format(initialDate!)
          : '',
    );

    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }
}

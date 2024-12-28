import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAlert extends StatelessWidget {
  final Function(Map<String, String>) onAddTask;
  final List<String> categories;

  CustomAlert({required this.onAddTask, required this.categories});

  @override
  Widget build(BuildContext context) {
    final _taskController = TextEditingController();
    final _descriptionController = TextEditingController();
    String selectedCategory = categories.isNotEmpty ? categories[0] : 'General';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    return AlertDialog(
      title: const Text('Add Task'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) {
                if (value != null) {
                  selectedCategory = value;
                }
              },
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              onTap: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
              },
              decoration: InputDecoration(
                labelText: selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : 'Select Date',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              onTap: () async {
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              decoration: InputDecoration(
                labelText: selectedTime != null
                    ? selectedTime!.format(context)
                    : 'Select Time',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_taskController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              onAddTask({
                'task': _taskController.text,
                'description': _descriptionController.text,
                'category': selectedCategory,
                'date': selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : 'No Date',
                'time': selectedTime != null
                    ? selectedTime!.format(context)
                    : 'No Time',
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}

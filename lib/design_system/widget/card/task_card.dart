import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/styles/spacing.dart';

class TugasCard extends StatelessWidget {
  final Map<String, String> task;
  final VoidCallback onTap;
  final Widget? trailing;

  const TugasCard({
    Key? key,
    required this.task,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorCollection.neutral500.withOpacity(0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          color: ColorCollection.primary100,
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorCollection.neutral200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task['category'] ?? 'Unknown Category',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ColorCollection.neutral600,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      Text(
                        task['title'] ?? 'Untitled Task',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorCollection.primary900,
                        ),
                      ),
                      const SizedBox(
                        height: Spacing.md,
                      ),
                      Text(
                        '${task['date'] ?? 'Unknown Date'} | ${task['time'] ?? 'Unknown Time'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorCollection.neutral600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

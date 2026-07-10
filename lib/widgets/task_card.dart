import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isCompleted;
  final bool isCompleting;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isCompleted = false,
    this.isCompleting = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 12),
      transform: Matrix4.identity()..scale(isCompleting ? 0.98 : 1.0),
      
      child: Card(
  elevation: isCompleting ? 1 : 3,
  shadowColor: Colors.black.withOpacity(0.50),
  color: isCompleting
      ? Colors.green.withOpacity(0.22)
      : Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(22),
  ),
  child: InkWell(
    borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isCompleted || isCompleting ? Colors.green : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
  title,
  style: TextStyle(
  fontSize: 17,
  color: isCompleted
      ? Colors.grey.shade600
      : const Color(0xFF454B54),

  decoration:
      isCompleted ? TextDecoration.lineThrough : null,

  decorationColor:
      isCompleted ? Colors.grey.shade500 : null,

  decorationThickness:
      isCompleted ? 2 : null,
),
),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
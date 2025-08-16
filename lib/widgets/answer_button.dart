import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;
  final bool isActive;

  const AnswerButton({
    super.key,
    required this.count,
    required this.onPressed,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.green : Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      onPressed: isActive ? onPressed : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            "የተመለሱት ($count/7)",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
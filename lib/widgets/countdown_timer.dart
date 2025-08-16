import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final Function onComplete;
  final Color? color;

  const CountdownTimer({
    super.key,
    required this.seconds,
    required this.onComplete,
    this.color,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remaining = widget.seconds;
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remaining > 0) {
        setState(() {
          remaining--;
        });
      } else {
        t.cancel();
        widget.onComplete();
      }
    });
  }

  Color get timerColor {
    if (remaining <= 10) return Colors.red;
    if (remaining <= 20) return Colors.orange;
    return widget.color ?? Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: timerColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: timerColor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: timerColor,
          ),
          const SizedBox(width: 8),
          Text(
            "$remaining ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: timerColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

void main() {
  runApp(const MaterialApp(home: ClockApp()));
}

class ClockApp extends StatefulWidget {
  const ClockApp({Key? key}) : super(key: key);

  @override
  State<ClockApp> createState() => _ClockAppState();
}

class _ClockAppState extends State<ClockApp> {
  late Timer _timer;
  late DateFormat _dateFormat;
  late DateFormat _timeFormat;
  String? _text;

  @override
  void initState() {
    super.initState();

    findSystemLocale().then((value) async {
      await initializeDateFormatting(value);
      _dateFormat = DateFormat.MMMEd();
      _timeFormat = DateFormat('aa hh:mm:ss');

      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        _updateText();
      });
    });
  }

  void _updateText() {
    DateTime now = DateTime.now();
    setState(() {
      _text = '${_dateFormat.format(now)} ${_timeFormat.format(now)}';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget get _clock {
    if (_text == null) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        _text!,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: _clock,
          ),
        ),
      ),
    );
  }
}

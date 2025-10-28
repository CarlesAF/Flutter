import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'pomodoro_widget.dart' show PomodoroWidget;
import 'package:flutter/material.dart';

class PomodoroModel extends FlutterFlowModel<PomodoroWidget> {
  ///  Local state fields for this page.

  bool timerSet = false;

  bool timerRunning = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Timer widget.
  final timerInitialTimeMs = 1200000;
  int timerMilliseconds = 1200000;
  String timerValue = StopWatchTimer.getDisplayTime(
    1200000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }
}

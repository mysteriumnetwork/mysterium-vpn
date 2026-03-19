part of 'hooks.dart';

/// A custom hook for a countdown timer.
///
/// [initialCountdown] is the starting value of the countdown in seconds.
/// Returns the current countdown value, a function to reset and start the timer, and a property to check if the timer is active.
({int countdown, void Function() reset}) useCountdownTimer({required int initialCountdown}) {
  final countdown = useState(initialCountdown);
  final timer = useRef<Timer?>(null);

  final startTimer = useCallback(() {
    timer.value?.cancel(); // Cancel any existing timer
    timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        if (countdown.value == 1) {
          countdown.value = 0; // Set to 0 when the countdown finishes
        }
        timer.cancel();
      }
    });
  }, [initialCountdown, countdown, timer]);

  void resetTimer() {
    countdown.value = initialCountdown; // Reset countdown value
    startTimer(); // Restart the timer
  }

  useEffect(() {
    startTimer(); // Start the timer when the hook is initialized

    // Cleanup the timer when the widget is disposed
    return () {
      timer.value?.cancel();
    };
  }, [initialCountdown, startTimer, timer, countdown]);

  return (countdown: countdown.value, reset: resetTimer);
}

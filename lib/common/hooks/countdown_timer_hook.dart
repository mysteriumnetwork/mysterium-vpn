part of 'hooks.dart';

/// A custom hook for a countdown timer.
///
/// [initialCountdown] is the starting value of the countdown in seconds.
/// Returns the current countdown value, a function to reset and start the timer, and a property to check if the timer is active.
({int countdown, void Function() reset, bool isActive}) useCountdownTimer({
  required int initialCountdown,
}) {
  final countdown = useState(initialCountdown);
  final timer = useRef<Timer?>(null);
  final isActive = useState(false); // Tracks if the timer is active

  void startTimer() {
    timer.value?.cancel(); // Cancel any existing timer
    isActive.value = true; // Mark the timer as active
    timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        if (countdown.value == 1) {
          countdown.value = 0; // Set to 0 when the countdown finishes
        }
        timer.cancel();
        isActive.value = false; // Mark the timer as inactive when it finishes
      }
    });
  }

  void resetTimer() {
    isActive.value = true;
    countdown.value = initialCountdown; // Reset countdown value
    startTimer(); // Restart the timer
  }

  useEffect(
    () {
      startTimer(); // Start the timer when the hook is initialized

      // Cleanup the timer when the widget is disposed
      return () {
        timer.value?.cancel();
        isActive.value = false; // Mark the timer as inactive when disposed
      };
    },
    [initialCountdown],
  );

  return (countdown: countdown.value, reset: resetTimer, isActive: isActive.value);
}

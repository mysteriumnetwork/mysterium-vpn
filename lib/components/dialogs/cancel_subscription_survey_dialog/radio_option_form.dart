part of 'cancel_subscription_dialog.dart';

class _RadioFormGroup extends FormGroup {
  _RadioFormGroup._()
    : super({
        'freezeDuration': FormControl<int>(validators: [Validators.required]),
      });

  FormControl<int> get freezeDuration => control('freezeDuration') as FormControl<int>;
}

_RadioFormGroup _useRadioForm() {
  final form = useMemoized(_RadioFormGroup._);
  useStream(form.valueChanges);
  return form;
}

class _RadioOptionForm extends StatelessWidget {
  const _RadioOptionForm({
    required this.form,
    required this.freezeDurations,
    required this.showError,
  });
  final _RadioFormGroup form;
  final List<int> freezeDurations;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ReactiveForm(
      formGroup: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final duration in freezeDurations)
            ReactiveRadioListTile<int>(
              formControlName: 'freezeDuration',
              value: duration,
              title: Text(_textForDuration(duration)),
            ),
          if (showError && form.freezeDuration.invalid)
            Padding(
              padding: EdgeInsets.only(top: theme.spacing.sm, left: theme.spacing.xl2),
              child: Text(
                'Please select one of the freeze durations.',
                style: theme.textStyles.textSm.regular.copyWith(
                  color: theme.palette.textErrorPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _textForDuration(int duration) {
    if (duration == 1) {
      return 'Freeze for 1 month';
    }

    return 'Freeze for $duration months';
  }
}

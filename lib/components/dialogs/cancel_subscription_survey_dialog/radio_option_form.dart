part of 'cancel_subscription_dialog.dart';

class _RadioFormGroup extends FormGroup {
  _RadioFormGroup._()
    : super({
        'freezeDuration': FormControl<String>(validators: [Validators.required]),
      });

  FormControl<String> get freezeDuration => control('freezeDuration') as FormControl<String>;
}

_RadioFormGroup _useRadioForm() {
  final form = useMemoized(_RadioFormGroup._);
  useStream(form.valueChanges);
  return form;
}

class RadioOptionForm extends StatelessWidget {
  const RadioOptionForm({required this.form, required this.items, super.key});

  final _RadioFormGroup form;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ReactiveForm(
      formGroup: form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReactiveRadioField(formControlName: 'freezeDuration', items: items),
          ReactiveFormConsumer(
            builder: (context, form, _) {
              if (form.control('freezeDuration').value == null) {
                return Padding(
                  padding: EdgeInsets.only(top: theme.spacing.sm),
                  child: Text(
                    'Please select one of the freeze durations to apply to your subscription.',
                    style: theme.textStyles.textSm.regular.copyWith(
                      color: theme.palette.textTertiary,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _RadioField extends StatelessWidget {
  const _RadioField({
    required this.items,
    required this.selection,
    required this.onSelectionChanged,
  });

  final List<String> items;
  final String? selection;
  final ValueChanged<String> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing.xl2,
      children: [
        for (final item in items)
          GestureDetector(
            onTap: () => onSelectionChanged(item),
            behavior: HitTestBehavior.opaque,
            child: Row(
              spacing: theme.spacing.lg,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IgnorePointer(
                  child: RadioButton<String>(value: item, selected: selection == item),
                ),
                Expanded(child: Text(item.tr(), style: theme.textStyles.textMd.medium)),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReactiveRadioField extends ReactiveFormField<String, String> {
  _ReactiveRadioField({required List<String> items, super.formControlName})
    : super(
        builder: (field) => _RadioField(
          items: items,
          selection: field.value,
          onSelectionChanged: (value) {
            field.didChange(value);
            field.control.markAsDirty();
          },
        ),
      );
}

part of 'cancel_subscription_survey_dialog.dart';

class _ReasonsField extends HookWidget {
  const _ReasonsField({
    required this.items,
    required this.selection,
    required this.onSelectionChanged,
  });

  final Set<String> items;
  final Set<String> selection;
  final ValueChanged<Set<String>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final axisCount = useResponsiveValue(1, tablet: 2, desktop: 2);

    void handleToggle(String value) {
      onSelectionChanged(selection.toggle(value));
    }

    final itemsList = items.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing.xl2,
      children: [
        for (int i = 0; i < itemsList.length; i += axisCount)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: theme.spacing.xl2,
            children: [
              for (int j = 0; j < axisCount; j++)
                if (i + j < itemsList.length)
                  Expanded(
                    child: CheckboxItem(
                      value: selection.contains(itemsList[i + j]),
                      onChanged: () => handleToggle(itemsList[i + j]),
                      label: Text(itemsList[i + j].tr(), style: theme.textStyles.textMd.medium),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
            ],
          ),
      ],
    );
  }
}

class _ReactiveReasonsField extends ReactiveFormField<Set<String>, Set<String>> {
  _ReactiveReasonsField({required Set<String> items, super.formControlName})
    : super(
        builder: (field) => _ReasonsField(
          items: items,
          selection: field.value ?? <String>{},
          onSelectionChanged: (value) {
            field.didChange(value);
            field.control.markAsDirty();
          },
        ),
      );
}

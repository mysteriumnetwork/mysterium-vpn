part of '../cancel_subscription_survey_dialog.dart';

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
    final axisCount = useResponsiveValue(1, tablet: 2, desktop: 2);

    void handleToggle(String value) {
      onSelectionChanged(selection.toggle(value));
    }

    final itemsList = items.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < itemsList.length; i += axisCount)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int j = 0; j < axisCount; j++)
                if (i + j < itemsList.length)
                  Expanded(
                    child: _Item(
                      value: itemsList[i + j],
                      isChecked: selection.contains(itemsList[i + j]),
                      onPressed: () => handleToggle(itemsList[i + j]),
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

class _Item extends StatelessWidget {
  const _Item({required this.value, required this.isChecked, required this.onPressed});

  final String value;
  final bool isChecked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CheckboxListTile(
      visualDensity: VisualDensity.compact,
      dense: true,
      contentPadding: EdgeInsets.zero,
      value: isChecked,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (_) => onPressed(),
      title: Text(value.tr(), style: theme.textStyles.textMd.medium, maxLines: 2),
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

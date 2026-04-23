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
      spacing: 24,
      children: [
        for (int i = 0; i < itemsList.length; i += axisCount)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
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
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: isChecked,
                onChanged: (_) => onPressed(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          Expanded(child: Text(value.tr(), style: theme.textStyles.textMd.medium)),
        ],
      ),
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

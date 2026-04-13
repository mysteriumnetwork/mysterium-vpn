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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount,
        mainAxisExtent: 60,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items.elementAt(index);
        return _Item(
          value: item,
          isChecked: selection.contains(item),
          onPressed: () => handleToggle(item),
        );
      },
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

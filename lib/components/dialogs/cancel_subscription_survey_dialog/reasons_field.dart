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

    return SliverGrid.builder(
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
    return ListTile(
      onTap: onPressed,
      leading: IgnorePointer(
        child: Checkbox(
          value: isChecked,
          onChanged: (_) {},
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Palette.purple
                : theme.palette.secondaryColor.withValues(alpha: .2),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: BorderSide(
            color: theme.palette.secondaryColor,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
      ),
      title: EasyText(value.tr(), maxLines: 2, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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

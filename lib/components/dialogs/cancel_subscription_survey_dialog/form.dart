part of 'cancel_subscription_survey_dialog.dart';

class _Form extends StatelessWidget {
  const _Form({required this.form, required this.items});

  final _FormGroup form;
  final Set<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ReactiveForm(
      formGroup: form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReactiveReasonsField(formControlName: 'reasons', items: items),
          Padding(
            padding: EdgeInsets.only(top: theme.spacing.xl2),
            child: ReactiveTextField(
              formControlName: 'feedback',
              maxLines: 5,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.palette.bgPrimary,
                contentPadding: const EdgeInsets.all(14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.palette.borderPrimary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.palette.borderBrand),
                ),
                hintText: LocaleKeys.cancelSurveyFeedbackHint.tr(),
                hintMaxLines: 3,
                hintStyle: theme.textStyles.textMd.regular.copyWith(
                  color: theme.palette.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormGroup extends FormGroup {
  _FormGroup._()
    : super(
        {
          'reasons': FormControl<Set<String>>(value: {}, validators: [Validators.minLength(1)]),
          'feedback': FormControl<String>(value: ''),
        },
        validators: [const _FeedbackLengthValidator(5)],
      );

  FormControl<Set<String>> get reasons => control('reasons') as FormControl<Set<String>>;

  FormControl<String> get feedback => control('feedback') as FormControl<String>;
}

class _FeedbackLengthValidator extends Validator<dynamic> {
  const _FeedbackLengthValidator(this.minLength);

  final int minLength;

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final form = control;
    if (form is! _FormGroup) {
      return null;
    }
    final reasons = form.reasons.value ?? const <String>{};
    final feedback = form.feedback.value ?? '';
    if (reasons.every((it) => it == kCancelReasonOther) && feedback.length < minLength) {
      return <String, dynamic>{
        'feedbackLength': {'requiredLength': minLength, 'actualLength': feedback.length},
      };
    }
    return null;
  }
}

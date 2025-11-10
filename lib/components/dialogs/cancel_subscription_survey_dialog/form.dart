part of '../cancel_subscription_survey_dialog.dart';

class _Form extends StatelessWidget {
  const _Form({
    required this.form,
    required this.items,
  });

  final _FormGroup form;
  final Set<String> items;

  @override
  Widget build(BuildContext context) => ReactiveForm(
        formGroup: form,
        child: SizedBox(
          width: double.maxFinite,
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              _ReactiveReasonsField(
                formControlName: 'reasons',
                items: items,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 32),
                  child: ReactiveTextField(
                    formControlName: 'feedback',
                    decoration: InputDecoration(
                      hintText: LocaleKeys.cancelSurveyFeedbackHint.tr(),
                      hintMaxLines: 3,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: ColorScheme.of(context).secondaryContainer,
                    ),
                    minLines: 3,
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _FormGroup extends FormGroup {
  _FormGroup._()
      : super(
          {
            'reasons': FormControl<Set<String>>(
              value: {},
              validators: [Validators.minLength(1)],
            ),
            'feedback': FormControl<String>(
              value: '',
            ),
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
        'feedbackLength': {
          'requiredLength': minLength,
          'actualLength': feedback.length,
        },
      };
    }
    return null;
  }
}

_FormGroup _useForm() {
  final form = useMemoized(_FormGroup._);
  useStream(form.valueChanges);
  return form;
}

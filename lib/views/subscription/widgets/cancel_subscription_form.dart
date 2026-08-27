part of '../cancel_subscription_survey_view.dart';

class _Form extends HookWidget {
  const _Form({required this.form, required this.items});

  final _FormGroup form;
  final Set<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feedbackKey = useMemoized(GlobalKey.new);
    final feedbackFocusNode = useFocusNode();

    useEffect(() {
      void onFocusChange() {
        if (!feedbackFocusNode.hasFocus) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = feedbackKey.currentContext;
          if (ctx != null && ctx.mounted) {
            Scrollable.ensureVisible(
              ctx,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: 0.1,
            );
          }
        });
      }

      feedbackFocusNode.addListener(onFocusChange);
      return () => feedbackFocusNode.removeListener(onFocusChange);
    }, [feedbackFocusNode]);

    return ReactiveForm(
      formGroup: form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReactiveReasonsField(formControlName: 'reasons', items: items),
          Padding(
            key: feedbackKey,
            padding: EdgeInsets.only(top: theme.spacing.xl2),
            child: ReactiveTextField(
              formControlName: 'feedback',
              focusNode: feedbackFocusNode,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              onTapOutside: (_) => feedbackFocusNode.unfocus(),
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
                hintText: S.current.cancelSurveyTellUsMoreHint,
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
    if (reasons.contains(kCancelReasonOther) && feedback.length < minLength) {
      return <String, dynamic>{
        'feedbackLength': {'requiredLength': minLength, 'actualLength': feedback.length},
      };
    }
    return null;
  }
}

_FormGroup _useForm() {
  final form = useMemoized(_FormGroup._);
  useStream(form.valueChanges);

  useEffect(() {
    final feedbackSub = form.feedback.valueChanges.listen((value) {
      if ((value ?? '').trim().isEmpty) {
        return;
      }
      final current = form.reasons.value ?? const <String>{};
      if (!current.contains(kCancelReasonOther)) {
        form.reasons.value = {...current, kCancelReasonOther};
      }
    });
    final reasonsSub = form.reasons.valueChanges.listen((value) {
      final hasOther = (value ?? {}).contains(kCancelReasonOther);
      final text = form.feedback.value ?? '';
      if (!hasOther && text.isNotEmpty) {
        form.feedback.value = '';
      }
    });
    return () {
      feedbackSub.cancel();
      reasonsSub.cancel();
    };
  }, [form]);

  return form;
}

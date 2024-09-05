import 'package:reactive_forms/reactive_forms.dart';

FormGroup singIn() => FormGroup({
      'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    });
FormGroup reportIssue() => FormGroup({
      'report_issue': FormControl<String>(validators: [Validators.required]),
    });

FormGroup marketingConsent() => FormGroup({
      'consent': FormControl<bool>(value: true),
    });
FormGroup emailConsent() => FormGroup({
      'consent': FormControl<bool>(value: true),
    });

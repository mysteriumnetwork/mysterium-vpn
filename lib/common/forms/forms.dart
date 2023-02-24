import 'package:reactive_forms/reactive_forms.dart';

FormGroup singUp() => FormGroup({
      'email': FormControl<String>(validators: [Validators.required, Validators.email]),
      'terms_acceptance':
          FormControl<bool>(validators: [Validators.required, Validators.requiredTrue]),
    });
FormGroup reportIssue() => FormGroup({
      'report_issue': FormControl<String>(validators: [Validators.required]),
    });

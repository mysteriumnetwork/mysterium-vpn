import 'package:reactive_forms/reactive_forms.dart';

FormGroup singIn() => FormGroup({
      'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    });
FormGroup reportIssue() => FormGroup({
      'report_issue': FormControl<String>(validators: [Validators.required]),
    });

FormGroup approval() => FormGroup({
      'approval': FormControl<bool>(value: true),
    });

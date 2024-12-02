import 'package:reactive_forms/reactive_forms.dart';

FormGroup singIn() => FormGroup({
      'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    });

FormGroup marketingConsent() => FormGroup({
      'consent': FormControl<bool>(value: true),
    });
FormGroup emailConsent() => FormGroup({
      'consent': FormControl<bool>(value: true),
    });

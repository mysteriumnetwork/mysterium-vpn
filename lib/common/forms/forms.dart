import 'package:reactive_forms/reactive_forms.dart';

abstract class AppForms {
  static FormGroup singUp() => FormGroup({
        'email': FormControl<String>(validators: [Validators.required, Validators.email]),
        'terms_acceptance': FormControl<bool>(validators: [Validators.required, Validators.requiredTrue]),
      });
}

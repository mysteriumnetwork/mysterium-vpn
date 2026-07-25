// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pl';

  static String m0(store) =>
      "Masz już aktywną subskrypcję opłacaną przez ${store}. Zarządzaj nią w ${store}.";

  static String m1(amount, period) => "${amount} /${period}";

  static String m2(amount, period) => "${amount}/miesiąc — rozliczane ${period}";

  static String m3(location) => "Połącz z ${location}";

  static String m4(couponCode) => "Skopiowano ${couponCode} do schowka!";

  static String m5(email) => "Wysłaliśmy e-mail na adres ${email}";

  static String m6(email) => "Możesz już mieć płatną subskrypcję na koncie „${email}”";

  static String m7(errorCode) => "Nie udało się połączyć. Spróbuj ponownie [błąd: ${errorCode}]";

  static String m8(plan) => "Wybierz ${plan}";

  static String m9(plan) => "Wybierz plan ${plan}";

  static String m10(count) => "Pula IP: ${count}";

  static String m11(location) =>
      "Brak alternatywnych IP w lokalizacji ${location}. Wybierz inny kraj lub miasto, aby następnym razem otrzymać inny adres IP.";

  static String m12(location) =>
      "Brak alternatywnych IP w lokalizacji ${location}. Wybierz inny kraj, aby następnym razem otrzymać inny adres IP.";

  static String m13(count) =>
      "${Intl.plural(count, one: '${count} miasto', few: '${count} miasta', many: '${count} miast', other: '${count} miasta')}";

  static String m14(count) =>
      "${Intl.plural(count, one: '${count} IP', few: '${count} IP', many: '${count} IP', other: '${count} IP')}";

  static String m15(count) =>
      "${Intl.plural(count, one: '${count} region', few: '${count} regiony', many: '${count} regionów', other: '${count} regionu')}";

  static String m16(location) => "${location} jest niedostępna";

  static String m17(location) => "Nie udało się zaktualizować ${location}";

  static String m18(location) => "Zaktualizowano ${location}";

  static String m19(date) => "Następne rozliczenie: ${date}";

  static String m20(count) =>
      "${Intl.plural(count, zero: '', one: 'Wstrzymaj na ${count} miesiąc', few: 'Wstrzymaj na ${count} miesiące', many: 'Wstrzymaj na ${count} miesięcy', other: 'Wstrzymaj na ${count} miesiąca')}";

  static String m21(protocol, label) => "${protocol} (${label})";

  static String m22(location) => "Odśwież ${location}";

  static String m23(count) =>
      "${Intl.plural(count, zero: 'Wyślij ponownie', one: 'Wyślij ponownie', few: 'Wyślij ponownie (${count})', many: 'Wyślij ponownie (${count})', other: 'Wyślij ponownie (${count})')}";

  static String m24(percent) => "Zaoszczędź ${percent}%";

  static String m25(percent, planId) => "Zaoszczędź ${percent}% z planem ${planId}";

  static String m26(plan) => "Przejdź na ${plan}";

  static String m27(plan) => "Przejdź na plan ${plan}";

  static String m28(location) => "Przełącz na ${location}";

  static String m29(word) => "Wpisz ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Logowanie…"),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Przyjmij ofertę"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Dostęp do:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "Brak dostępu do zablokowanych stron",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Konto"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Konto usunięte"),
    "activeSubsPaidVia": m0,
    "allLocations": MessageLookupByLibrary.simpleMessage("Wszystkie lokalizacje"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("Zezwól"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Zezwól na powiadomienia"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("Zezwól na powiadomienia"),
    "and": MessageLookupByLibrary.simpleMessage(" i "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "Nowa wersja aplikacji jest dostępna! Zaktualizuj teraz, aby korzystać z najnowszych funkcji i ulepszeń.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage(
      "Dostępna aktualizacja aplikacji!",
    ),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("Dostępna aktualizacja"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Wygląd"),
    "ar": MessageLookupByLibrary.simpleMessage("Arabski"),
    "austria": MessageLookupByLibrary.simpleMessage("Austria"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "Nie można się zalogować. Spróbuj ponownie.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Wstecz"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Wróć do ustawień"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("Oszczędzanie baterii"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlin, Niemcy 🇩🇪"),
    "billedInTotal": m1,
    "billedPerMonth": m2,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Bloker"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Zaktualizuj teraz"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Omijanie ograniczeń"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("Anuluj"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Rozłączenia"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Przestoje"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Błąd 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Opóźnienia"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Brakujące funkcje"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Prędkość"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Czy na pewno chcesz anulować subskrypcję?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Anuluj subskrypcję"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "Twoja subskrypcja zostanie anulowana. Możesz nadal korzystać z Mysterium VPN do końca dostępu.",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage("Podaj więcej szczegółów…"),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage(
      "Powiedz nam więcej (opcjonalnie)",
    ),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("Powody anulowania"),
    "cancelSurveyTitleOptional": MessageLookupByLibrary.simpleMessage(
      "Powody anulowania (opcjonalnie)",
    ),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Zbyt drogie"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "Brak dostępu do zablokowanych stron",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Problemy z użytecznością"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Przed usunięciem konta anuluj subskrypcję w subskrypcjach App Store.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("Data anulowania:"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "Nie możemy pobrać informacji o Twoim planie.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Informacje o planie są niedostępne",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage("Pobieranie informacji o planie…"),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("Sprawdź swoją pocztę"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Wyczyść wyszukiwanie"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Zamknij"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("Komunikacja"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("KOMUNIKACJA"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Zakończ"),
    "confirm": MessageLookupByLibrary.simpleMessage("Potwierdź"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("Potwierdź anulowanie"),
    "connect": MessageLookupByLibrary.simpleMessage("Połącz"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("Najlepszy serwer"),
    "connectToLocationBtn": m3,
    "connected": MessageLookupByLibrary.simpleMessage("Połączono"),
    "connecting": MessageLookupByLibrary.simpleMessage("Łączenie…"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Łączenie z operatorem płatności…",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Połączenie"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Połączenie i ochrona"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Przekroczono limit czasu połączenia. Spróbuj ponownie później. Jeśli problem będzie się powtarzać, skontaktuj się z zespołem wsparcia",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Stała prędkość"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "Działa tylko na urządzeniu, które go zażądało – kliknij link w e-mailu, aby kontynuować.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Dalej"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "Zostaniesz przekierowany na stronę Mysterium VPN, aby dokończyć anulowanie.",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "Kontynuuj anulowanie w sieci",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("Kontynuuj anulowanie"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("Przejdź na stronę"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Kontynuuj z Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("Kontynuuj z e-mailem"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Kontynuuj z Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Skopiuj link i wklej go w przeglądarce"),
    "couponCodeCopied": m4,
    "dark": MessageLookupByLibrary.simpleMessage("Ciemny"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Łatwe do wykrycia"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Często blokowane przez strony",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Mniej prywatne"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP DATA CENTER"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("Większość VPN-ów"),
    "de": MessageLookupByLibrary.simpleMessage("Niemiecki"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Usuń konto"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("Usunąć konto?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Usuń"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "Osiągnięto maksymalną liczbę połączonych urządzeń. Aby dodać nowe urządzenie, usuń jedno z konta.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("Otwórz panel"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("Osiągnięto limit urządzeń"),
    "disconnect": MessageLookupByLibrary.simpleMessage("Rozłącz"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Rozłączono"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Rozłączanie…"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Tylko"),
    "dns": MessageLookupByLibrary.simpleMessage("Ochrona DNS"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("Zapobiega wyciekom DNS"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Gotowe"),
    "duration": MessageLookupByLibrary.simpleMessage("Czas trwania"),
    "email": MessageLookupByLibrary.simpleMessage("Adres e-mail"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("Adres e-mail jest nieprawidłowy"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("Adres e-mail jest wymagany"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("Powiadomienia e-mail"),
    "emailSentTo": m5,
    "en": MessageLookupByLibrary.simpleMessage("Angielski"),
    "es": MessageLookupByLibrary.simpleMessage("Hiszpański"),
    "existingSubscriptionDesc": m6,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "Możesz się wylogować i spróbować ze swoim e-mailem lub zignorować to ostrzeżenie",
    ),
    "failedToConnectError": m7,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "Nie udało się wysłać opinii. Spróbuj ponownie.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Coś poszło nie tak z Twoją subskrypcją. Spróbuj ponownie!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "Nie udało się zweryfikować Twojego ostatniego zakupu subskrypcji. Naciśnij przycisk poniżej, aby spróbować ponownie.",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("Szybki"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "Twoja wersja aplikacji jest nieaktualna. Zaktualizuj aplikację, aby dalej z niej korzystać.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Nieprawidłowe dane formularza. Sprawdź pola i spróbuj ponownie.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Francuski"),
    "france": MessageLookupByLibrary.simpleMessage("Francja"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("Częste rozłączenia"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Cena pełna:"),
    "germany": MessageLookupByLibrary.simpleMessage("Niemcy"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage(
      "Uzyskaj nowy adres IP przy odświeżaniu",
    ),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Zabezpiecz połączenie i ciesz się prywatnym przeglądaniem od razu",
    ),
    "getSubscriptionModalTitle": m8,
    "getSubscriptionPlanBtn": m9,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("Pobieranie adresu IP…"),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Wróć"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Przejdź do logowania"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Pomoc i wsparcie"),
    "hi": MessageLookupByLibrary.simpleMessage("Hindi"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Ukryty"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("Wysokie opóźnienia"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Centrum danych"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Ekran główny"),
    "id": MessageLookupByLibrary.simpleMessage("Indonezyjski"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Nieprawidłowa lokalizacja"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage(
      "Nieprawidłowy magiczny link. Spróbuj ponownie.",
    ),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("Adres IP"),
    "ipPoolLabel": m10,
    "ipRefreshExhaustedCity": m11,
    "ipRefreshExhaustedCountry": m12,
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("IP z centrów danych"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "IP z centrów danych zoptymalizowane pod kątem prędkości i wydajności.",
    ),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("IP mieszkaniowe"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Dostarczane przez prawdziwe gospodarstwa domowe. Prawie niewykrywalne, ale mniej stabilne.",
    ),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "IP mieszkaniowe są dostarczane przez prawdziwe urządzenia domowe, więc ich dostępność może się zmieniać w czasie.\n\nGdy węzeł przejdzie w tryb offline, aplikacja ponownie połączy Cię z najbliższym dostępnym mieszkaniowym IP.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "Dlaczego mój adres IP może się zmieniać?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("Włoski"),
    "italy": MessageLookupByLibrary.simpleMessage("Włochy"),
    "ja": MessageLookupByLibrary.simpleMessage("Japoński"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Zachowaj subskrypcję"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "Blokuje ruch internetowy, gdy połączenie VPN zostanie przerwane",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Język"),
    "light": MessageLookupByLibrary.simpleMessage("Jasny"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Link skopiowany do schowka!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "Link wygasa po 30 minutach i może zostać użyty tylko raz.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Lokalizacja"),
    "locationItemCityCount": m13,
    "locationItemNodeCount": m14,
    "locationItemStatesCount": m15,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Lokalizacja"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("Połącz z najbliższym IP"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "Połącz z najbliższym IP – lub wybierz je ręcznie",
    ),
    "locationUnavailableTitle": m16,
    "locationsUpdateFailed": m17,
    "locationsUpdated": m18,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Twoja sesja wygasła. Zaloguj się ponownie.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Zaloguj się lub zarejestruj"),
    "logout": MessageLookupByLibrary.simpleMessage("Wyloguj się"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "Zaraz się wylogujesz. Na pewno?",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Wyloguj się"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN jest włączony. Jeśli będziesz kontynuować wylogowanie, połączenie z serwerem VPN zostanie przerwane.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Niskie opóźnienia"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madryt, Hiszpania 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Złośliwe oprogramowanie"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Zarządzaj w sieci"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Czy chcesz otrzymywać aktualizacje e-mail, wskazówki dotyczące prywatności i oferty specjalne od Mysterium Network?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Bądź na bieżąco przez e-mail",
    ),
    "month": MessageLookupByLibrary.simpleMessage("miesiąc"),
    "monthly": MessageLookupByLibrary.simpleMessage("miesięcznie"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Lokalizacje"),
    "navMap": MessageLookupByLibrary.simpleMessage("Mapa"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Produkty"),
    "nextBilling": m19,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Następna data rozliczenia:"),
    "no": MessageLookupByLibrary.simpleMessage("Nie"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("Nie masz aktywnej subskrypcji"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage(
      "Na Twoim urządzeniu nie ma aplikacji pocztowych.",
    ),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("Nie znaleziono lokalizacji"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("Brak dostępnych serwerów"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "Wystąpił problem z łącznością i żaden serwer nie jest dostępny. Spróbuj później.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Wybierz plan"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Brak aktywnego planu"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("Brak"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("Niedostępne"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Nie teraz"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage("Nie chcesz jeszcze anulować?"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW i złośliwe oprogramowanie"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "Twój adres IP i lokalizacja są widoczne dla stron, trackerów i publicznych sieci Wi-Fi.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage(
      "Twoje połączenie jest odsłonięte",
    ),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN maskuje Twój adres IP, dostawcę internetu i lokalizację, byś mógł przeglądać sieć z prawdziwą prywatnością.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Ukryj swoją prawdziwą tożsamość jednym dotknięciem",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "Dzięki IP mieszkaniowym Twoje połączenie wygląda naturalnie – nie jak typowy ruch VPN.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage(
      "Nie wszystkie VPN-y działają tak samo",
    ),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("Otwórz aplikację pocztową"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Otwórz ustawienia systemowe"),
    "or": MessageLookupByLibrary.simpleMessage("LUB"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "Połączymy Cię z najlepszym serwerem – lub możesz ręcznie wybrać kraj.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Inne…"),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Wybierz okres wstrzymania.",
    ),
    "pauseForMonths": m20,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Wstrzymaj subskrypcję"),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Możesz wstrzymać swój plan raz na cykl rozliczeniowy.",
    ),
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "Masz już trwającą transakcję płatniczą. Dokończ ją przed rozpoczęciem nowej.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("mies."),
    "pl": MessageLookupByLibrary.simpleMessage("Polski"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "Wszystko gotowe! Masz już ten plan aktywny.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("Plan 2-letni"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 lata"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 lata"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("Plan 6-miesięczny"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Plan miesięczny"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic miesięcznie"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus miesięcznie"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro miesięcznie"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Plan roczny"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic rocznie"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus rocznie"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro rocznie"),
    "poland": MessageLookupByLibrary.simpleMessage("Polska"),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferencje"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("Zobacz wszystkie plany"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Polityka prywatności"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "Przetwarzamy Twoją płatność. Za chwilę wszystko będzie gotowe…",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "Masz już aktywny plan. Ulepsz go w sieci – zmiany synchronizują się automatycznie",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("Wszystkie plany:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "Podstawy codziennej prywatności",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 miesiąc"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 rok"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 lata"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("Poznaj plany i funkcje"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("Zarządzaj i ulepszaj w sieci"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "Masz już najwyższy dostępny plan.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Obecnie nie ma dostępnych produktów. Spróbuj ponownie później.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage(
      "Więcej urządzeń, więcej lokalizacji",
    ),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Maksymalna ochrona dla wymagających użytkowników",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "Subskrypcjami zarządza się w sieci. Twój plan zsynchronizuje się z aplikacją automatycznie.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("Subskrybuj w sieci"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("Produkty VPN"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("CHRONIONY"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protokół"),
    "protocolLabel": m21,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Zmiana protokołu VPN spowoduje rozłączenie. Następnie trzeba będzie połączyć się ponownie.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("Zmiana protokołu VPN"),
    "pt": MessageLookupByLibrary.simpleMessage("Portugalski"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Portugalski brazylijski"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Otrzymuj informacje o nowych funkcjach, przydatnych wskazówkach i ekskluzywnych ofertach – same przydatne aktualizacje.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Bądź na bieżąco dzięki powiadomieniom push",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Powiadomienia push"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Aktualizacje produktu, wskazówki i oferty specjalne",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("Jak działa Twoje połączenie?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("Co Ci się nie podobało?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("Co Ci się podobało?"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "Możesz ponownie aktywować subskrypcję w dowolnym momencie przed końcem dostępu.",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Ostatnie lokalizacje"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("Wykorzystaj kod rabatowy"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Twoje konto zostało pomyślnie usunięte. Nastąpi przekierowanie do ekranu logowania.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Odśwież"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("Odśwież IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("Odśwież adres IP"),
    "refreshLocationsTooltip": m22,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("Zresetuj, gdy coś nie działa"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "Jeśli zresetujesz aplikację, zostaniesz odłączony od Mysterium VPN.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Połączenie VPN jest obecnie aktywne",
    ),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "Nie udało się zresetować aplikacji. Spróbuj ponownie.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage(
      "Aplikacja została zresetowana pomyślnie.",
    ),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("Zresetuj aplikację"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Resetuj"),
    "residential": MessageLookupByLibrary.simpleMessage("Mieszkaniowe"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Wygląda jak prawdziwy użytkownik",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Trudniejsze do wykrycia",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Mniej blokad"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP MIESZKANIOWE"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "IP mieszkaniowe pochodzą z prawdziwych urządzeń domowych, dzięki czemu Twój ruch wygląda jak zwykłe korzystanie z internetu.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage(
      "Prawdziwe urządzenia domowe",
    ),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Ponieważ te adresy IP pochodzą z prawdziwych urządzeń, niektóre węzły mogą od czasu do czasu być offline.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "Dostępność może się zmieniać",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "Gdy Twój bieżący adres IP stanie się niedostępny, aplikacja ponownie połączy Cię z najbliższym dostępnym mieszkaniowym IP.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage(
      "Automatyczne ponowne połączenie",
    ),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("Rozumiem"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "IP mieszkaniowe różnią się od IP z centrów danych. Oto, czego można się spodziewać.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage(
      "Jak działają IP mieszkaniowe",
    ),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Ponów"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Napisz recenzję"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "Świetnie! Czy zechcesz zostawić nam recenzję?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "Czy polecisz tę aplikację innym?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Szukaj lokalizacji"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("Zobacz plany"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage(
      "Wybierz aplikację pocztową, aby kontynuować",
    ),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("co pół roku"),
    "sendAgain": m23,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "Występują tymczasowe problemy z siecią. Spróbuj ponownie później.",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Zarządzaj"),
    "settings": MessageLookupByLibrary.simpleMessage("Ustawienia"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Aby korzystać z Mysterium VPN, potrzebujemy Twojej zgody na instalację profilu VPN.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Twoja anonimowość jest bezpieczna. Nie widzimy, nie zbieramy ani nie przechowujemy żadnej Twojej aktywności w sieci.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Potrzebujemy Twojej zgody",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Zaloguj się do Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Logowanie przerwane"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Zaloguj się"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN nie rejestruje Twojej aktywności online, a żadne dane nie są powiązane z Tobą, Twoim urządzeniem, adresem IP ani e-mailem. Logując się, akceptujesz nasze",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 miesięcy"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Pomiń"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Coś poszło nie tak. Spróbuj ponownie!",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Stabilne połączenie"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Zostań"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("Zostań w aplikacji"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Wyślij"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("Subskrybuj w sieci"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "Świetna wiadomość! Twoja subskrypcja jest już aktywna.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Wróć do planów"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "Porównaj wszystkie funkcje",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Bieżący plan"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Wybierz plan"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Miesięcznie"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 rok"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("Wszystkie plany"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Ulepsz swój plan"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("Subskrypcja anulowana"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "Odkryj zaawansowane funkcje, takie jak protokoły VPN i blokowanie złośliwego oprogramowania.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Zwiększ swoją ochronę",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("Pomiń na razie"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "Połączymy Cię z najlepszym serwerem.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Połącz, aby zachować prywatność",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Kup, ulepsz lub przeglądaj dostępne plany w zależności od dostępu do konta.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage(
      "Zarządzaj swoim planem",
    ),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Przeglądaj mapę lub odkrywaj lokalizacje z paska bocznego.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Odkrywaj lokalizacje po swojemu",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Przeglądaj mapę, aby wybrać kraj i połączyć się natychmiast.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage("Połącz z mapy"),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Poznaj zaktualizowaną aplikację i dowiedz się, gdzie znajdują się kluczowe funkcje.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Zrób szybki przegląd",
    ),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Szybko znajduj kraje, miasta i serwery dzięki wyszukiwarce.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Szukaj i łącz się szybciej",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Wybierz lokalizację, aby zacząć przeglądać sieć bardziej prywatnie.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Konfiguracja zakończona",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage(
      "Rozpocznij przegląd",
    ),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Odkrywaj kraje i miasta w jednym miejscu.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Odkrywaj kraje, miasta, ostatnie połączenia i serwery specjalne w jednym miejscu.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "Przeglądaj lokalizacje VPN",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("NAJLEPSZA OFERTA"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("Wybór na poziomie miast"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Zapewnia dokładniejszą kontrolę lokalizacji niż większość VPN-ów, które zwykle pozwalają wybrać jedynie cały kraj lub region.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Urządzeń zabezpieczonych naraz",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("Double VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Dodatkowa warstwa zabezpieczeń. Kieruje Twój ruch internetowy przez dwa różne serwery VPN, dwukrotnie szyfrując dane i maskując adres IP za drugim serwerem",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage(
      "Bloker złośliwego oprogramowania",
    ),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Chroni Twoje urządzenie, zatrzymując zagrożenia, zanim do niego dotrą, działając cicho w tle bez przeszkadzania.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "7-dniowa gwarancja zwrotu pieniędzy",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage("Zabezpiecz 6 urządzeń naraz"),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage("Zabezpiecz 10 urządzeń naraz"),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 obsługiwanych krajów"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage(
      "Ponad 100 obsługiwanych krajów",
    ),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 serwerów"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 serwerów"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("Protokół VPN"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("Ponad 7500 IP mieszkaniowych"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("Protokół VPN"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("Wybór na poziomie miast"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("IP mieszkaniowe"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Wyglądaj jak zwykły użytkownik domowy, co pozwala korzystać z usług streamingowych i unikać wykrycia VPN.",
    ),
    "subscriptionPlanSavePercent": m24,
    "subscriptionPlanSaveWith": m25,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Serwery"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage("Obsługiwane kraje"),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("Protokół VPN"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard – szybki protokół najlepszy do gier i streamingu\nOpenVPN – bardzo konfigurowalny protokół, który działa tam, gdzie inne zawodzą (niedostępny na Androidzie)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "Zmiany w subskrypcji nie zostały dokończone.",
    ),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Ulepsz"),
    "subscriptionUpgradeCTA": m26,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "aby uzyskać dostęp do ponad 7500 IP mieszkaniowych",
    ),
    "subscriptionUpgradeModalTitle": m27,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage(
      "Zobacz wszystkie plany",
    ),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("Ponów weryfikację"),
    "subscripton": MessageLookupByLibrary.simpleMessage("Subskrypcja"),
    "switchToLocationBtn": m28,
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("Odzyskaj internet."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Regulamin"),
    "title": MessageLookupByLibrary.simpleMessage("Witaj"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Zbyt wiele żądań. Spróbuj ponownie później.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage(
      "Token został już użyty. Spróbuj ponownie.\n",
    ),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Rozłącz"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("Połącz ponownie"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "Osiągnięto maksymalny limit 6 połączonych urządzeń na Twoim koncie. Aby dalej korzystać z VPN, kliknij, aby połączyć ponownie.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "Osiągnięto maksymalny limit 6 połączonych urządzeń na Twoim koncie. Aby dalej korzystać z VPN, kliknij rozłącz i spróbuj ponownie.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage(
      "Połączenie zostało przerwane",
    ),
    "topLocations": MessageLookupByLibrary.simpleMessage("Najlepsze lokalizacje"),
    "tr": MessageLookupByLibrary.simpleMessage("Turecki"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Spróbuj ponownie"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage("Spróbuj wyszukać inną lokalizację"),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Musisz udzielić pozwolenia, aby uruchomić tunel VPN.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage(
      "Wystąpił błąd podczas konfigurowania tunelu",
    ),
    "typeDelete": m29,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Wpisz tutaj swoją opinię…"),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ukraina"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Nie można połączyć się z operatorem płatności! Spróbuj ponownie.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("Nie zalogowano"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Zaloguj się, aby uzyskać dostęp do konta i odblokować wszystkie funkcje",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("Nie zalogowano"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("NIECHRONIONY"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Niestabilna prędkość"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Zaktualizuj"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("Najlepsza prędkość"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "Połącz z najszybszym dostępnym serwerem dla optymalnej wydajności",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Serwer specjalny"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Niskie opóźnienia"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Automatycznie łączy Cię z najbliższym serwerem dla stabilnego i niezawodnego dostępu",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Maks. prywatność"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Uzyskaj serwer z najlepszymi opcjami wolności słowa i prędkości w zależności od kraju",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("Najbliższa lokalizacja"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Łączy Cię z najbliższym dostępnym IP VPN dla najlepszej prędkości i wydajności na podstawie Twojej bieżącej lokalizacji",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Wybierz najlepszy serwer do bezpiecznych transakcji kryptowalutowych, udostępniania plików, hostowania gier i komunikacji",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Uzyskaj dostęp do ulubionych seriali i filmów z platform dostępnych w danym regionie",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("Zobacz wszystkie funkcje"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("Zobacz mniej"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("Protokół VPN"),
    "year": MessageLookupByLibrary.simpleMessage("rok"),
    "yearly": MessageLookupByLibrary.simpleMessage("rocznie"),
    "yes": MessageLookupByLibrary.simpleMessage("Tak"),
    "zh": MessageLookupByLibrary.simpleMessage("Chiński"),
  };
}

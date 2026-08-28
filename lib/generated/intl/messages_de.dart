// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(date) => "Zugang verfügbar bis ${date}";

  static String m1(store) =>
      "Du hast bereits ein aktives Abo, das über ${store} bezahlt wird. Verwalte es in ${store}.";

  static String m2(amount, period) => "${amount} /${period}";

  static String m3(amount, period) => "${amount}/Monat — Abrechnung ${period}";

  static String m4(location) => "Mit ${location} verbinden";

  static String m5(couponCode) => "${couponCode} in die Zwischenablage kopiert!";

  static String m6(email) => "Wir haben eine E-Mail an ${email} gesendet";

  static String m7(email) =>
      "Du hast möglicherweise bereits ein kostenpflichtiges Abonnement mit „${email}“";

  static String m8(errorCode) =>
      "Verbindung fehlgeschlagen. Bitte versuche es erneut [Fehler: ${errorCode}]";

  static String m9(plan) => "${plan} holen";

  static String m10(plan) => "${plan}-Plan holen";

  static String m11(count) => "IP-Pool: ${count}";

  static String m12(location) =>
      "In ${location} sind keine alternativen IPs verfügbar. Wähle ein anderes Land oder eine andere Stadt, um beim nächsten Mal eine andere IP zu erhalten.";

  static String m13(location) =>
      "In ${location} sind keine alternativen IPs verfügbar. Wähle ein anderes Land, um beim nächsten Mal eine andere IP zu erhalten.";

  static String m14(count) =>
      "${Intl.plural(count, zero: '${count} Städte', one: '${count} Stadt', other: '${count} Städte')}";

  static String m15(count) =>
      "${Intl.plural(count, zero: '${count} IPs', one: '${count} IP', other: '${count} IPs')}";

  static String m16(count) =>
      "${Intl.plural(count, zero: '${count} Staaten', one: '${count} Staat', other: '${count} Staaten')}";

  static String m17(location) => "${location} ist nicht verfügbar";

  static String m18(location) => "${location} konnte nicht aktualisiert werden";

  static String m19(location) => "${location} aktualisiert";

  static String m20(date) => "Nächste Abrechnung: ${date}";

  static String m21(count) =>
      "${Intl.plural(count, zero: 'Für ${count} Monate pausieren', one: 'Für ${count} Monat pausieren', other: 'Für ${count} Monate pausieren')}";

  static String m22(date) => "Pausiert bis ${date}";

  static String m23(location) => "${location} aktualisieren";

  static String m24(date) => "Verlängert am ${date}";

  static String m25(count) =>
      "${Intl.plural(count, zero: 'Erneut senden', one: 'Erneut senden', other: 'Erneut senden (${count})')}";

  static String m26(percent) => "${percent}% sparen";

  static String m27(percent, planId) => "Spare ${percent}% mit einem ${planId}-Plan";

  static String m28(plan) => "Upgrade auf ${plan}";

  static String m29(plan) => "Upgrade auf ${plan}-Plan";

  static String m30(location) => "Zu ${location} wechseln";

  static String m31(word) => "Gib ${word} ein";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Du wirst angemeldet..."),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Angebot annehmen"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Zugang verfügbar bis:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "Zugriff auf blockierte Websites nicht möglich",
    ),
    "accessUntil": m0,
    "account": MessageLookupByLibrary.simpleMessage("Konto"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Konto gelöscht"),
    "activeSubsPaidVia": m1,
    "allLocations": MessageLookupByLibrary.simpleMessage("Alle Standorte"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("Zulassen"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Benachrichtigungen zulassen"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage(
      "Benachrichtigungen zulassen",
    ),
    "and": MessageLookupByLibrary.simpleMessage(" und "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "Die neue App-Version ist da! Aktualisiere jetzt für die neuesten Funktionen und Verbesserungen.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("App-Update verfügbar!"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("App-Update verfügbar"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Aussehen"),
    "ar": MessageLookupByLibrary.simpleMessage("Arabisch"),
    "austria": MessageLookupByLibrary.simpleMessage("Österreich"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "Anmeldung fehlgeschlagen. Bitte versuche es erneut.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Zurück"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Zurück zu den Einstellungen"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlin, Deutschland 🇩🇪"),
    "billedInTotal": m2,
    "billedPerMonth": m3,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Blocker"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Jetzt aktualisieren"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Einschränkungen umgehen"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Verbindungsabbrüche"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Ausfallzeiten"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Fehler 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Latenz"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Fehlende Funktionen"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Geschwindigkeit"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Möchtest du dein Abo wirklich kündigen?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Abo kündigen"),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage(
      "Erzähl uns mehr (optional)",
    ),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("Gründe für die Kündigung"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Zu teuer"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "Kein Zugriff auf gesperrte Seiten",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Nutzbarkeitsprobleme"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Kündige dein Abonnement im App Store, bevor du dein Konto löschst.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("Kündigungsdatum:"),
    "cancelled": MessageLookupByLibrary.simpleMessage("Gekündigt"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "Wir können deine Planinformationen nicht abrufen.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Planinformationen sind nicht verfügbar",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Planinformationen werden abgerufen...",
    ),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("Überprüfe deine E-Mails"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Suche löschen"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Schließen"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("Kommunikation"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("KOMMUNIKATION"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Fertig"),
    "confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
    "connect": MessageLookupByLibrary.simpleMessage("Verbinden"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("Bester Server"),
    "connectToLocationBtn": m4,
    "connected": MessageLookupByLibrary.simpleMessage("Verbunden"),
    "connectedSince": MessageLookupByLibrary.simpleMessage("Verbunden seit"),
    "connecting": MessageLookupByLibrary.simpleMessage("Wird verbunden"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Verbindung zum Zahlungsabwickler wird hergestellt...",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Verbindung"),
    "connectionDetails": MessageLookupByLibrary.simpleMessage("Verbindungsdetails"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Verbindung & Schutz"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Zeitüberschreitung der Verbindung. Bitte später erneut versuchen. Falls das Problem bestehen bleibt, wende dich an den Support.",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Konstante Geschwindigkeit"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "Er funktioniert nur auf dem Gerät, das ihn angefordert hat – klicke auf den Link in deiner E-Mail, um fortzufahren.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Fortfahren"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "Du wirst zur Mysterium VPN-Website weitergeleitet, um die Kündigung abzuschließen.",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "Kündigung im Web fortsetzen",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("Weiter zur Kündigung"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("Zur Website"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Weiter mit Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("Weiter mit E-Mail"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Weiter mit Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage(
      "Kopiere den Link und füge ihn in deinen Browser ein",
    ),
    "couponCodeCopied": m5,
    "dark": MessageLookupByLibrary.simpleMessage("Dunkel"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Leicht erkennbar"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Oft von Websites blockiert",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Weniger privat"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("RECHENZENTRUMS-IPS"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("Die meisten VPNs"),
    "datacenterIpBadge": MessageLookupByLibrary.simpleMessage("Datacenter-IP"),
    "de": MessageLookupByLibrary.simpleMessage("Deutsch"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Konto löschen"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("Konto löschen?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Löschen"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "Du hast die maximale Anzahl verbundener Geräte erreicht. Um ein neues Gerät hinzuzufügen, entferne ein vorhandenes aus deinem Konto.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("Dashboard öffnen"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("Gerätelimit erreicht"),
    "disconnect": MessageLookupByLibrary.simpleMessage("Trennen"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Getrennt"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Wird getrennt"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Nur"),
    "dismissNewIpPreview": MessageLookupByLibrary.simpleMessage("Vorschau der neuen IP schließen"),
    "dns": MessageLookupByLibrary.simpleMessage("DNS-Schutz"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("Verhindert DNS-Leaks"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Fertig"),
    "duration": MessageLookupByLibrary.simpleMessage("Dauer"),
    "email": MessageLookupByLibrary.simpleMessage("E-Mail-Adresse"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("E-Mail-Adresse ist ungültig"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("E-Mail-Adresse wird benötigt"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("E-Mail-Benachrichtigungen"),
    "emailSentTo": m6,
    "en": MessageLookupByLibrary.simpleMessage("Englisch"),
    "es": MessageLookupByLibrary.simpleMessage("Spanisch"),
    "existingSubscriptionDesc": m7,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "Du kannst dich abmelden und es mit deiner E-Mail versuchen oder diese Warnung ignorieren",
    ),
    "failedToConnectError": m8,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "Feedback konnte nicht gesendet werden. Bitte versuche es erneut.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Bei deinem Abo ist etwas schiefgelaufen. Bitte versuche es erneut!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "Wir konnten deinen letzten Abo-Kauf nicht prüfen. Tippe unten, um es erneut zu versuchen.",
    ),
    "favoriteIpAddAction": MessageLookupByLibrary.simpleMessage("Zu Favoriten-IPs hinzufügen"),
    "favoriteIpAddedToast": MessageLookupByLibrary.simpleMessage("IP zu Favoriten hinzugefügt"),
    "favoriteIpLimitReached": MessageLookupByLibrary.simpleMessage(
      "Limit für Favoriten-IPs erreicht. Entferne eine IP, um eine neue zu speichern.",
    ),
    "favoriteIpRemoveAction": MessageLookupByLibrary.simpleMessage("Aus Favoriten-IPs entfernen"),
    "favoriteIpRemovedToast": MessageLookupByLibrary.simpleMessage("IP aus Favoriten entfernt"),
    "favoriteIpsDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Die Verfügbarkeit gespeicherter IPs kann sich mit der Zeit ändern. Deine Favoriten-IP war nicht mehr verfügbar, daher haben wir dich mit dem nächstgelegenen verfügbaren Standort verbunden.",
    ),
    "favoriteIpsEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Verbinde dich und tippe auf das Herz auf der Verbindungskarte, um eine IP für den schnellen Zugriff zu speichern.",
    ),
    "favoriteIpsEmptyTitle": MessageLookupByLibrary.simpleMessage("Noch keine Favoriten-IPs"),
    "favoriteIpsLabel": MessageLookupByLibrary.simpleMessage("Favoriten-IPs"),
    "favoriteIpsLockedBody": MessageLookupByLibrary.simpleMessage(
      "Mach ein Upgrade auf Plus oder Pro, um IPs zu speichern, die gut für dich funktionieren, und sie jederzeit schnell aufzurufen.",
    ),
    "favoriteIpsLockedTitle": MessageLookupByLibrary.simpleMessage("Favoriten-IPs speichern"),
    "favoriteIpsNotAvailableOnPlan": MessageLookupByLibrary.simpleMessage(
      "Gespeicherte IPs sind in deinem aktuellen Plan nicht verfügbar.",
    ),
    "favoriteIpsTab": MessageLookupByLibrary.simpleMessage("Favoriten"),
    "favoriteIpsUnavailableHeading": MessageLookupByLibrary.simpleMessage("Nicht verfügbare IPs"),
    "favoriteIpsUpgradePlan": MessageLookupByLibrary.simpleMessage("Plan upgraden"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "Deine App-Version ist veraltet. Bitte aktualisiere die App, um sie weiterhin zu nutzen.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Ungültige Formulardaten. Bitte überprüfe die Felder und versuche es erneut.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Französisch"),
    "france": MessageLookupByLibrary.simpleMessage("Frankreich"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage(
      "Häufige Verbindungsabbrüche",
    ),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Voller Preis:"),
    "germany": MessageLookupByLibrary.simpleMessage("Deutschland"),
    "getAPlanBtn": MessageLookupByLibrary.simpleMessage("Einen Plan holen"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage(
      "Beim Aktualisieren eine neue IP-Adresse erhalten",
    ),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Sichere deine Verbindung und genieße sofort privates Surfen",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("IP-Adresse wird abgerufen..."),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Zurück"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Zur Anmeldung"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Hilfe & Support"),
    "hi": MessageLookupByLibrary.simpleMessage("Hindi"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Verborgen"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("Hohe Latenz"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Startseite"),
    "id": MessageLookupByLibrary.simpleMessage("Indonesisch"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Falscher Standort"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage(
      "Falscher Magic Link. Bitte versuche es erneut.",
    ),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("IP-Adresse"),
    "ipDetails": MessageLookupByLibrary.simpleMessage("IP-Details"),
    "ipPool": MessageLookupByLibrary.simpleMessage("IP-Pool"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipType": MessageLookupByLibrary.simpleMessage("IP-Typ"),
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("Datacenter-IPs"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Datacenter-IPs, optimiert für Geschwindigkeit und Leistung.",
    ),
    "ipTypeDataCenterTab": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Haushalts-IPs"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Bereitgestellt von echten Haushalten. Nahezu unerkennbar, aber weniger stabil.",
    ),
    "ipTypeResidentialTab": MessageLookupByLibrary.simpleMessage("Haushalt"),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "Haushalts-IPs stammen von echten Haushaltsgeräten, daher kann sich die Verfügbarkeit im Laufe der Zeit ändern.\n\nWenn ein Knoten offline geht, verbindet dich die App mit der nächstgelegenen verfügbaren Haushalts-IP.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "Warum kann sich meine IP ändern?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("Italienisch"),
    "italy": MessageLookupByLibrary.simpleMessage("Italien"),
    "ja": MessageLookupByLibrary.simpleMessage("Japanisch"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Abo behalten"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "Blockiert den Internetverkehr, wenn die VPN-Verbindung abbricht",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Sprache"),
    "light": MessageLookupByLibrary.simpleMessage("Hell"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Link in die Zwischenablage kopiert!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "Der Link ist 30 Minuten gültig und kann nur einmal verwendet werden.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Standort"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Standort"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("Mit nächster IP verbinden"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "Verbinde dich mit der nächsten IP – oder wähle sie manuell aus",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Deine Sitzung ist abgelaufen. Bitte melde dich erneut an.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Anmelden oder registrieren"),
    "logout": MessageLookupByLibrary.simpleMessage("Abmelden"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "Du bist dabei, dich abzumelden. Bist du sicher?",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Abmelden"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN ist aktiv. Wenn du dich abmeldest, wird die VPN-Verbindung getrennt.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Niedrige Latenz"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madrid, Spanien 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Malware"),
    "manageFavoriteIpsBtn": MessageLookupByLibrary.simpleMessage("Verwalten"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Im Web verwalten"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Möchtest du E-Mail-Updates, Datenschutztipps und Sonderangebote von Mysterium Network erhalten?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Bleib per E-Mail auf dem Laufenden",
    ),
    "month": MessageLookupByLibrary.simpleMessage("Monat"),
    "monthly": MessageLookupByLibrary.simpleMessage("monatlich"),
    "myIp": MessageLookupByLibrary.simpleMessage("Meine IP"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Standorte"),
    "navMap": MessageLookupByLibrary.simpleMessage("Karte"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Produkte"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Nächstes Abrechnungsdatum:"),
    "no": MessageLookupByLibrary.simpleMessage("Nein"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("Du hast kein aktives Abo"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage(
      "Auf deinem Gerät sind keine E-Mail-Apps vorhanden.",
    ),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("Keine Standorte gefunden"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("Keine Server verfügbar"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "Es besteht ein Verbindungsproblem und es sind keine Server verfügbar. Bitte versuche es später.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Plan holen"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Kein aktiver Plan verfügbar"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("Keine"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("Nicht verfügbar"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Nicht jetzt"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage("Noch nicht bereit zu kündigen?"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW & Malware"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "Deine IP-Adresse und dein Standort sind für Websites, Tracker und öffentliche Wi-Fi-Netzwerke sichtbar.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage(
      "Deine Verbindung ist ungeschützt",
    ),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN maskiert deine IP, deinen ISP und deinen Standort, sodass du mit echter Privatsphäre surfen kannst.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Verbirg deine wahre Identität mit einem Tippen",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "Mit Haushalts-IPs sieht deine Verbindung natürlich aus – nicht wie typischer VPN-Verkehr.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage(
      "Nicht alle VPNs funktionieren gleich",
    ),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("E-Mail-App öffnen"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Systemeinstellungen öffnen"),
    "optional": MessageLookupByLibrary.simpleMessage("optional"),
    "or": MessageLookupByLibrary.simpleMessage("ODER"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "Wir verbinden dich mit dem besten Server – oder du kannst manuell ein Land auswählen.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Andere..."),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Bitte wähle eine Pausendauer.",
    ),
    "pauseForMonths": m21,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Abo pausieren"),
    "pauseSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "Dein Abo konnte nicht pausiert werden. Bitte versuche es erneut.",
    ),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Du kannst dein Abo einmal pro Abrechnungszyklus pausieren.",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("Pausiert"),
    "pausedUntil": m22,
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "Du hast bereits einen laufenden Zahlungsvorgang. Bitte schließe ihn ab, bevor du einen neuen startest.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("Mon."),
    "pl": MessageLookupByLibrary.simpleMessage("Polnisch"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "Alles bereit! Du hast diesen Plan bereits aktiv.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("2-Jahres-Plan"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 Jahre"),
    "plan_2_years_plus": MessageLookupByLibrary.simpleMessage("Plus 2 Jahre"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 Jahre"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("6-Monats-Plan"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Monatsplan"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic monatlich"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus monatlich"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro monatlich"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Jahresplan"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic jährlich"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus jährlich"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro jährlich"),
    "poland": MessageLookupByLibrary.simpleMessage("Polen"),
    "preferences": MessageLookupByLibrary.simpleMessage("Allgemein"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("Alle Pläne anzeigen"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Datenschutzrichtlinie"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "Wir verarbeiten deine Zahlung. In Kürze bist du startklar…",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "Du hast bereits einen aktiven Plan. Upgrade im Web — Änderungen werden automatisch synchronisiert.",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("Alle Pläne:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "Grundlegendes für alltägliche Privatsphäre",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 Monat"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 Jahr"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 Jahre"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage(
      "Pläne und Funktionen entdecken",
    ),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("Verwalten und upgraden im Web"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "Du hast bereits den höchsten verfügbaren Plan.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Derzeit sind keine Produkte verfügbar. Bitte versuche es später erneut.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage("Mehr Geräte, mehr Standorte"),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Maximaler Schutz für Vielnutzer",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "Abos werden im Web verwaltet. Dein Plan wird automatisch mit der App synchronisiert.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("Im Web abonnieren"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("VPN-Produkte"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("GESCHÜTZT"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protokoll"),
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Durch das Wechseln des VPN-Protokolls wird die Verbindung getrennt. Du musst dich danach erneut verbinden.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("VPN-Protokoll wechseln"),
    "pt": MessageLookupByLibrary.simpleMessage("Portugiesisch"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Brasilianisches Portugiesisch"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Lass dich über neue Funktionen, hilfreiche Tipps und exklusive Angebote informieren – nur nützliche Updates.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Bleib mit Push-Benachrichtigungen auf dem Laufenden",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Push-Benachrichtigungen"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Produktupdates, Tipps und Sonderangebote",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("Wie ist deine Verbindung?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("Was hat dir nicht gefallen?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("Was hat dir gefallen?"),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Zuletzt verwendet"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("Gutscheincode einlösen"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Dein Konto wurde erfolgreich gelöscht. Du wirst zum Anmeldebildschirm weitergeleitet.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Aktualisieren"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("IP aktualisieren"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("IP-Adresse erneuern"),
    "refreshLocationsTooltip": m23,
    "renewsOn": m24,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage(
      "Zurücksetzen, wenn etwas nicht funktioniert",
    ),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "Wenn du mit dem Zurücksetzen der App fortfährst, wirst du vom Mysterium VPN getrennt.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Die VPN-Verbindung ist derzeit aktiv",
    ),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "App konnte nicht zurückgesetzt werden. Bitte versuche es erneut.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("App wurde erfolgreich zurückgesetzt."),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("App zurücksetzen"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
    "residential": MessageLookupByLibrary.simpleMessage("Haushalt"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Sieht aus wie ein echter Nutzer",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Schwerer zu erkennen",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage(
      "Weniger Blockaden",
    ),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("HAUSHALTS-IPS"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "Haushalts-IPs stammen von echten Haushaltsgeräten, sodass dein Traffic wie normale Internetaktivität aussieht.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage(
      "Echte Haushaltsgeräte",
    ),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Da diese IPs von echten Geräten stammen, können einzelne Nodes von Zeit zu Zeit offline gehen.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "Die Verfügbarkeit kann sich ändern",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "Wenn deine aktuelle IP nicht mehr verfügbar ist, verbindet dich die App mit der nächstgelegenen verfügbaren Haushalts-IP.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage(
      "Automatische Wiederverbindung",
    ),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("Verstanden"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Haushalts-IPs unterscheiden sich von Datacenter-IPs. Das erwartet dich.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage(
      "Wie Haushalts-IPs funktionieren",
    ),
    "residentialIpBadge": MessageLookupByLibrary.simpleMessage("Haushalts-IP"),
    "resumeBtn": MessageLookupByLibrary.simpleMessage("Fortsetzen"),
    "resumeSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "Dein Abo konnte nicht fortgesetzt werden. Bitte versuche es erneut.",
    ),
    "resumeSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Dein Abo wird sofort fortgesetzt.",
    ),
    "resumeSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Abo fortsetzen?"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Wiederholen"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Bewertung abgeben"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "Super! Würdest du uns eine Bewertung hinterlassen?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "Würdest du diese App weiterempfehlen?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Nach Standorten suchen"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("Pläne ansehen"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage(
      "Wähle eine E-Mail-App, um fortzufahren",
    ),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("halbjährlich"),
    "sendAgain": m25,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "Vorübergehende Netzwerkprobleme. Bitte später erneut versuchen.",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Verwalten"),
    "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Um Mysterium VPN nutzen zu können, benötigen wir deine Erlaubnis zur Installation eines VPN-Profils.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Deine Anonymität ist sicher. Wir sehen, sammeln oder speichern keine deiner Browsing-Aktivitäten.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Wir benötigen deine Erlaubnis",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Bei Mysterium VPN anmelden"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Anmeldung abgebrochen"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Anmelden"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN protokolliert deine Online-Aktivitäten nicht, und es werden keine Daten mit dir, deinem Gerät, deiner IP-Adresse oder deiner E-Mail verknüpft. Mit der Anmeldung akzeptierst du unsere",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 Monate"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Überspringen"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Es ist ein Fehler aufgetreten. Bitte versuche es erneut!",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Stabile Verbindung"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Bleiben"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("In der App bleiben"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Absenden"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("Im Web abonnieren"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "Tolle Neuigkeiten! Dein Abo ist jetzt aktiv.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Zurück zu den Plänen"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "Alle Funktionen vergleichen",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Aktueller Plan"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Plan holen"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Monatlich"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 Jahr"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("Alle Pläne"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Plan upgraden"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "Entdecke erweiterte Funktionen wie VPN-Protokolle und Malware-Blockierung.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Verstärke deinen Schutz",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage(
      "Vorerst überspringen",
    ),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "Wir verbinden dich mit dem besten Server.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Verbinde dich, um privat zu bleiben",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Kaufe, upgrade oder sieh dir verfügbare Pläne je nach deinem Kontozugriff an.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage(
      "Verwalte deinen Plan",
    ),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Stöbere auf der Karte oder entdecke Standorte über die Seitenleiste.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Entdecke Standorte auf deine Weise",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Durchsuche die Karte, um ein Land auszuwählen und dich sofort zu verbinden.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "Verbinde dich über die Karte",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Mach dich mit der aktualisierten App vertraut und entdecke, wo sich die wichtigsten Funktionen jetzt befinden.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Mach eine kurze Tour",
    ),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Finde mit der Suche schnell Länder, Städte und Server.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Schneller suchen und verbinden",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Wähle einen Standort, um privater zu surfen.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Einrichtung abgeschlossen",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("Tour starten"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Entdecke Länder und Städte an einem Ort.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Entdecke Länder, Städte, aktuelle Verbindungen und Spezialserver an einem Ort.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "VPN-Standorte durchsuchen",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("BESTPREIS"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("Auswahl auf Stadtebene"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Bietet eine präzisere Standortkontrolle als die meisten VPNs, die dich in der Regel auf die Auswahl ganzer Länder oder Staaten beschränken.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Gleichzeitig gesicherte Geräte",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("Doppeltes VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Zusätzliche Sicherheitsebene. Leitet deinen Internetverkehr über zwei verschiedene VPN-Server, verschlüsselt deine Daten doppelt und maskiert deine IP-Adresse hinter einem zweiten Server",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("Malware-Blocker"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Schützt dein Gerät, indem es Bedrohungen abwehrt, bevor diese es erreichen, und läuft dabei unauffällig im Hintergrund, ohne dich zu stören.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "7-Tage-Geld-zurück-Garantie",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage(
      "6 Geräte gleichzeitig sichern",
    ),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage(
      "10 Geräte gleichzeitig sichern",
    ),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 unterstützte Länder"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage(
      "Mehr als 100 unterstützte Länder",
    ),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 Server"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 Server"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("VPN-Protokoll"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("7.500+ Haushalts-IPs"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("VPN-Protokoll"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("Auswahl auf Stadtebene"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("Haushalts-IPs"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Erscheine als normaler Heimanwender, um auf Streaming-Dienste zuzugreifen und eine VPN-Erkennung zu vermeiden.",
    ),
    "subscriptionPlanSavePercent": m26,
    "subscriptionPlanSaveWith": m27,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Server"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage(
      "Unterstützte Länder",
    ),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("VPN-Protokoll"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard – schnelles Protokoll, ideal für Gaming und Streaming\nOpenVPN – hochgradig konfigurierbares Protokoll, das auch dort funktioniert, wo andere versagen (nicht für Android verfügbar)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "Du hast die Änderungen an deinem Abo nicht abgeschlossen.",
    ),
    "subscriptionResumed": MessageLookupByLibrary.simpleMessage("Dein Abo ist wieder aktiv."),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Upgrade"),
    "subscriptionUpgradeCTA": m28,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "für Zugriff auf 7.500+ Haushalts-IPs",
    ),
    "subscriptionUpgradeModalTitle": m29,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("Alle Pläne anzeigen"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage(
      "Überprüfung wiederholen",
    ),
    "subscripton": MessageLookupByLibrary.simpleMessage("Abonnement"),
    "switchToLocationBtn": m30,
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("Hol dir das Internet zurück."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Geschäftsbedingungen"),
    "title": MessageLookupByLibrary.simpleMessage("Hallo"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Zu viele Anfragen. Bitte versuche es später erneut.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage(
      "Token bereits verwendet. Bitte versuche es erneut.\n",
    ),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Trennen"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage(
      "Erneut verbinden",
    ),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "Du hast die maximale Anzahl von 6 verbundenen Geräten auf deinem Konto erreicht. Um VPN weiterhin zu nutzen, klicke zum erneuten Verbinden.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "Du hast die maximale Anzahl von 6 verbundenen Geräten auf deinem Konto erreicht. Um VPN weiterhin zu nutzen, klicke auf „Trennen“ und versuche es erneut.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("Du wurdest getrennt"),
    "topLocations": MessageLookupByLibrary.simpleMessage("Top-Standorte"),
    "tr": MessageLookupByLibrary.simpleMessage("Türkisch"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Erneut versuchen"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage(
      "Versuche, nach einem anderen Standort zu suchen",
    ),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Du musst die Berechtigung erteilen, um den VPN-Tunnel zu starten.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage(
      "Beim Einrichten des Tunnels ist ein Fehler aufgetreten",
    ),
    "typeDelete": m31,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Gib hier dein Feedback ein..."),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ukraine"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Es konnte keine Verbindung zum Zahlungsabwickler hergestellt werden! Bitte versuche es erneut.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("Du bist nicht angemeldet"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Melde dich an, um auf dein Konto zuzugreifen und alle Funktionen freizuschalten",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("Du bist nicht angemeldet"),
    "undo": MessageLookupByLibrary.simpleMessage("Rückgängig"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("UNGESCHÜTZT"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Instabile Geschwindigkeit"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Aktualisieren"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("Beste Geschwindigkeit"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "Verbinde dich mit dem schnellsten verfügbaren Server für optimale Leistung",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Spezialserver"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Niedrige Latenz"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Verbindet dich automatisch mit dem nächstgelegenen Server für stabilen und zuverlässigen Zugriff",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Maximale Privatsphäre"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Erhalte einen Server mit den besten Optionen für Meinungsfreiheit und Geschwindigkeit je nach Land",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("Nächster Standort"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Verbindet dich mit der nächstgelegenen verfügbaren VPN-IP für optimale Geschwindigkeit und Leistung basierend auf deinem aktuellen Standort",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Wähle den besten Server für sichere Krypto-Transaktionen, Dateifreigabe, Game-Hosting und Kommunikation",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Greife auf deine Lieblingsserien und -filme von regionalspezifischen Plattformen zu",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("Alle Funktionen anzeigen"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("Weniger anzeigen"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnDetails": MessageLookupByLibrary.simpleMessage("VPN-Details"),
    "vpnIp": MessageLookupByLibrary.simpleMessage("VPN-IP"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("VPN-Protokoll"),
    "year": MessageLookupByLibrary.simpleMessage("Jahr"),
    "yearly": MessageLookupByLibrary.simpleMessage("jährlich"),
    "yes": MessageLookupByLibrary.simpleMessage("Ja"),
    "zh": MessageLookupByLibrary.simpleMessage("Chinesisch"),
  };
}

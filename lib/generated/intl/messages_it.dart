// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static String m0(date) => "Accesso disponibile fino al ${date}";

  static String m1(store) =>
      "Hai già un abbonamento attivo pagato tramite ${store}. Gestiscilo in ${store}.";

  static String m2(amount, period) => "${amount} /${period}";

  static String m3(amount, period) => "${amount}/mese — Fatturato ${period}";

  static String m4(location) => "Connetti a ${location}";

  static String m5(couponCode) => "${couponCode} copiato negli appunti!";

  static String m6(email) => "Abbiamo inviato un\'email a ${email}";

  static String m7(email) => "Potresti già avere un abbonamento a pagamento con “${email}”";

  static String m8(errorCode) => "Connessione non riuscita. Riprova [errore: ${errorCode}]";

  static String m9(plan) => "Ottieni ${plan}";

  static String m10(plan) => "Ottieni il piano ${plan}";

  static String m11(count) => "Pool IP: ${count}";

  static String m12(location) =>
      "Nessun IP alternativo è disponibile in ${location}. Scegli un altro paese o città per ottenere un IP diverso la prossima volta.";

  static String m13(location) =>
      "Nessun IP alternativo è disponibile in ${location}. Scegli un altro paese per ottenere un IP diverso la prossima volta.";

  static String m14(count) =>
      "${Intl.plural(count, zero: '${count} città', one: '${count} città', other: '${count} città')}";

  static String m15(count) =>
      "${Intl.plural(count, zero: '${count} IP', one: '${count} IP', other: '${count} IP')}";

  static String m16(count) =>
      "${Intl.plural(count, zero: '${count} stati', one: '${count} stato', other: '${count} stati')}";

  static String m17(location) => "${location} non è disponibile";

  static String m18(location) => "Impossibile aggiornare ${location}";

  static String m19(location) => "${location} aggiornato";

  static String m20(date) => "Prossima fatturazione: ${date}";

  static String m21(count) =>
      "${Intl.plural(count, zero: 'Pausa di ${count} mesi', one: 'Pausa di ${count} mese', other: 'Pausa di ${count} mesi')}";

  static String m22(date) => "In pausa fino al ${date}";

  static String m23(location) => "Aggiorna ${location}";

  static String m24(date) => "Si rinnova il ${date}";

  static String m25(count) =>
      "${Intl.plural(count, zero: 'Invia di nuovo', one: 'Invia di nuovo', other: 'Invia di nuovo (${count})')}";

  static String m26(percent) => "Risparmia ${percent}%";

  static String m27(percent, planId) => "Risparmia ${percent}% con un piano ${planId}";

  static String m28(plan) => "Passa a ${plan}";

  static String m29(plan) => "Passa al piano ${plan}";

  static String m30(location) => "Passa a ${location}";

  static String m31(word) => "Digita ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Accesso in corso..."),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Accetta offerta"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Accesso disponibile fino al:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "Impossibile accedere ai siti bloccati",
    ),
    "accessUntil": m0,
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Account eliminato"),
    "activeSubsPaidVia": m1,
    "allLocations": MessageLookupByLibrary.simpleMessage("Tutte le posizioni"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("Consenti"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Consenti notifiche"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("Consenti notifiche"),
    "and": MessageLookupByLibrary.simpleMessage(" e "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "È disponibile la nuova versione dell\'app! Aggiorna ora per le ultime funzionalità e i miglioramenti.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("Aggiornamento disponibile!"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("Aggiornamento disponibile"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Aspetto"),
    "ar": MessageLookupByLibrary.simpleMessage("Arabo"),
    "austria": MessageLookupByLibrary.simpleMessage("Austria"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage("Impossibile accedere. Riprova."),
    "back": MessageLookupByLibrary.simpleMessage("Indietro"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Torna alle impostazioni"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlino, Germania 🇩🇪"),
    "billedInTotal": m2,
    "billedPerMonth": m3,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Blocco"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Aggiorna ora"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Aggira le restrizioni"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("Annulla"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Disconnessioni"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Interruzioni"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Errore 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Latenza"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Funzionalità mancanti"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Velocità"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Sei sicuro di voler annullare l’abbonamento?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Annulla abbonamento"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "Il tuo abbonamento verrà annullato. Potrai continuare a usare Mysterium VPN fino alla fine dell’accesso.",
    ),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage(
      "Raccontaci di più (facoltativo)",
    ),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("Motivi dell\'annullamento"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Troppo costoso"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "Impossibile accedere ai siti bloccati",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Problemi di usabilità"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Annulla l\'abbonamento negli abbonamenti dell\'App Store prima di eliminare il tuo account.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("Data di annullamento:"),
    "cancelled": MessageLookupByLibrary.simpleMessage("Annullato"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "Non riusciamo a recuperare le informazioni sul tuo piano.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Informazioni sul piano non disponibili",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Recupero delle informazioni sul piano...",
    ),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("Controlla la tua email"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Cancella ricerca"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Chiudi"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("Comunicazioni"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("COMUNICAZIONI"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Completa"),
    "confirm": MessageLookupByLibrary.simpleMessage("Conferma"),
    "connect": MessageLookupByLibrary.simpleMessage("Connetti"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("Miglior server"),
    "connectToLocationBtn": m4,
    "connected": MessageLookupByLibrary.simpleMessage("Connesso"),
    "connectedSince": MessageLookupByLibrary.simpleMessage("Connesso da"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connessione in corso"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Connessione al processore di pagamento...",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Connessione"),
    "connectionDetails": MessageLookupByLibrary.simpleMessage("Dettagli connessione"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Connessione e protezione"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Connessione scaduta. Riprova più tardi. Se il problema persiste, contatta il team di supporto",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Velocità costante"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "Funziona solo sul dispositivo che l\'ha richiesto - tocca il link nella tua email per continuare.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Continua"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "Verrai reindirizzato al sito Mysterium VPN per completare l’annullamento.",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "Continua l’annullamento sul web",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("Continua l’annullamento"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("Vai al sito"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Continua con Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("Continua con l\'email"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Continua con Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copia il link e incollalo nel browser"),
    "couponCodeCopied": m5,
    "dark": MessageLookupByLibrary.simpleMessage("Scuro"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Facilmente rilevabili"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Spesso bloccati dai siti",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Meno privati"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP DATA CENTER"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage(
      "La maggior parte delle VPN",
    ),
    "datacenterIpBadge": MessageLookupByLibrary.simpleMessage("IP datacenter"),
    "de": MessageLookupByLibrary.simpleMessage("Tedesco"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Elimina account"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("Eliminare l\'account?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Elimina"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "Hai raggiunto il numero massimo di dispositivi connessi. Per aggiungerne uno nuovo, rimuovine uno esistente dal tuo account.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("Apri dashboard"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("Limite dispositivi raggiunto"),
    "disconnect": MessageLookupByLibrary.simpleMessage("Disconnetti"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Disconnesso"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Disconnessione in corso"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Solo"),
    "dismissNewIpPreview": MessageLookupByLibrary.simpleMessage("Chiudi anteprima della nuova IP"),
    "dns": MessageLookupByLibrary.simpleMessage("Protezione DNS"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("Previene le fughe DNS"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Fatto"),
    "duration": MessageLookupByLibrary.simpleMessage("Durata"),
    "email": MessageLookupByLibrary.simpleMessage("Indirizzo email"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("Indirizzo email non valido"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("L\'indirizzo email è obbligatorio"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notifiche email"),
    "emailSentTo": m6,
    "en": MessageLookupByLibrary.simpleMessage("Inglese"),
    "es": MessageLookupByLibrary.simpleMessage("Spagnolo"),
    "existingSubscriptionDesc": m7,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "Puoi disconnetterti e provare con la tua email o ignorare questo avviso",
    ),
    "failedToConnectError": m8,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "Invio del feedback non riuscito. Riprova.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Qualcosa è andato storto con il tuo abbonamento. Riprova!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "Non siamo riusciti a verificare il tuo ultimo acquisto dell\'abbonamento. Tocca il pulsante qui sotto per riprovare.",
    ),
    "favoriteIpAddAction": MessageLookupByLibrary.simpleMessage("Aggiungi alle IP preferite"),
    "favoriteIpAddedToast": MessageLookupByLibrary.simpleMessage("IP aggiunta ai preferiti"),
    "favoriteIpLimitReached": MessageLookupByLibrary.simpleMessage(
      "Limite di IP preferite raggiunto. Rimuovi un’IP per salvarne una nuova.",
    ),
    "favoriteIpRemoveAction": MessageLookupByLibrary.simpleMessage("Rimuovi dalle IP preferite"),
    "favoriteIpRemovedToast": MessageLookupByLibrary.simpleMessage("IP rimossa dai preferiti"),
    "favoriteIpsDisclaimer": MessageLookupByLibrary.simpleMessage(
      "La disponibilità delle IP salvate può cambiare nel tempo. La tua IP preferita non era più disponibile, quindi ti abbiamo collegato alla posizione disponibile più vicina.",
    ),
    "favoriteIpsEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Connettiti e tocca il cuore sulla scheda di connessione per salvare un’IP e accedervi rapidamente.",
    ),
    "favoriteIpsEmptyTitle": MessageLookupByLibrary.simpleMessage("Nessuna IP preferita"),
    "favoriteIpsLabel": MessageLookupByLibrary.simpleMessage("IP preferite"),
    "favoriteIpsLockedBody": MessageLookupByLibrary.simpleMessage(
      "Passa a Plus o Pro per salvare le IP che funzionano meglio per te e accedervi rapidamente quando ti servono.",
    ),
    "favoriteIpsLockedTitle": MessageLookupByLibrary.simpleMessage("Salva le IP preferite"),
    "favoriteIpsNotAvailableOnPlan": MessageLookupByLibrary.simpleMessage(
      "Le IP salvate non sono disponibili nel tuo piano attuale.",
    ),
    "favoriteIpsTab": MessageLookupByLibrary.simpleMessage("Preferite"),
    "favoriteIpsUnavailableHeading": MessageLookupByLibrary.simpleMessage("IP non disponibili"),
    "favoriteIpsUpgradePlan": MessageLookupByLibrary.simpleMessage("Aggiorna piano"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "La versione dell\'app è obsoleta. Aggiorna l\'app per continuare a usarla.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Dati del modulo non validi. Controlla i campi e riprova.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Francese"),
    "france": MessageLookupByLibrary.simpleMessage("Francia"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("Disconnessioni frequenti"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Prezzo pieno:"),
    "germany": MessageLookupByLibrary.simpleMessage("Germania"),
    "getAPlanBtn": MessageLookupByLibrary.simpleMessage("Ottieni un piano"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage(
      "Ottieni un nuovo indirizzo IP all\'aggiornamento",
    ),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Proteggi la tua connessione e goditi subito la navigazione privata",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("Recupero dell\'indirizzo IP..."),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Torna indietro"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Vai all\'accesso"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Aiuto e supporto"),
    "hi": MessageLookupByLibrary.simpleMessage("Hindi"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Nascosto"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("Latenza elevata"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Home"),
    "id": MessageLookupByLibrary.simpleMessage("Indonesiano"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Posizione errata"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage("Magic link errato. Riprova."),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("Indirizzo IP"),
    "ipDetails": MessageLookupByLibrary.simpleMessage("Dettagli IP"),
    "ipPool": MessageLookupByLibrary.simpleMessage("Pool di IP"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipType": MessageLookupByLibrary.simpleMessage("Tipo di IP"),
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("IP datacenter"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "IP datacenter ottimizzati per velocità e prestazioni.",
    ),
    "ipTypeDataCenterTab": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("IP residenziali"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Forniti da famiglie reali. Quasi non rilevabili ma meno stabili.",
    ),
    "ipTypeResidentialTab": MessageLookupByLibrary.simpleMessage("Residenziale"),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "Gli IP residenziali sono forniti da dispositivi domestici reali, quindi la disponibilità può cambiare nel tempo.\n\nSe un nodo va offline, l\'app ti riconnette all\'IP residenziale disponibile più vicino.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "Perché il mio IP può cambiare?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("Italiano"),
    "italy": MessageLookupByLibrary.simpleMessage("Italia"),
    "ja": MessageLookupByLibrary.simpleMessage("Giapponese"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Mantieni abbonamento"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "Blocca il traffico internet se la connessione VPN si interrompe",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Lingua"),
    "light": MessageLookupByLibrary.simpleMessage("Chiaro"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Link copiato negli appunti!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "Il link scade tra 30 minuti e può essere usato una sola volta.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Posizione"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Posizione"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage(
      "Connetti all\'IP più vicino",
    ),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "Connetti all\'IP più vicino - o scegli manualmente",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "La tua sessione è scaduta. Accedi di nuovo.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Accedi o registrati"),
    "logout": MessageLookupByLibrary.simpleMessage("Esci"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage("Stai per uscire. Sei sicuro?"),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Esci"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "La VPN è attiva. Verrai disconnesso dal server VPN se continui con il logout.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Bassa latenza"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madrid, Spagna 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Malware"),
    "manageFavoriteIpsBtn": MessageLookupByLibrary.simpleMessage("Gestisci"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Gestisci sul web"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Vuoi ricevere aggiornamenti via email, consigli sulla privacy e offerte speciali da Mysterium Network?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Resta aggiornato via email",
    ),
    "month": MessageLookupByLibrary.simpleMessage("mese"),
    "monthly": MessageLookupByLibrary.simpleMessage("mensile"),
    "myIp": MessageLookupByLibrary.simpleMessage("Il mio IP"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Posizioni"),
    "navMap": MessageLookupByLibrary.simpleMessage("Mappa"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Prodotti"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Prossima data di fatturazione:"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("Non hai un abbonamento attivo"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage(
      "Non ci sono app email sul tuo dispositivo.",
    ),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("Nessuna posizione trovata"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("Nessun server disponibile"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "C\'è un problema di connettività e nessun server è disponibile. Riprova più tardi.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Ottieni il piano"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Nessun piano attivo disponibile"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("Nessuno"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("Non disponibile"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Non ora"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage(
      "Non sei ancora pronto ad annullare?",
    ),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW e malware"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "Il tuo IP e la tua posizione sono visibili a siti, tracker e reti Wi-Fi pubbliche.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("La tua connessione è esposta"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN maschera il tuo IP, il tuo ISP e la tua posizione così puoi navigare con vera privacy.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Nascondi la tua vera identità con un tocco",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "Con gli IP residenziali, la tua connessione sembra naturale - non il tipico traffico VPN.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage(
      "Non tutte le VPN funzionano allo stesso modo",
    ),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("Apri l\'app email"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Apri impostazioni di sistema"),
    "optional": MessageLookupByLibrary.simpleMessage("facoltativo"),
    "or": MessageLookupByLibrary.simpleMessage("O"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "Ti connetteremo al server migliore - oppure puoi selezionare manualmente un paese.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Altro..."),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Seleziona una durata della pausa.",
    ),
    "pauseForMonths": m21,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Metti in pausa"),
    "pauseSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "Impossibile mettere in pausa l\'abbonamento. Riprova.",
    ),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Puoi mettere in pausa il tuo piano una volta per ciclo di fatturazione.",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("In pausa"),
    "pausedUntil": m22,
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "Hai già una transazione di pagamento in corso. Completala prima di iniziarne una nuova.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("mese"),
    "pl": MessageLookupByLibrary.simpleMessage("Polacco"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "Tutto pronto! Hai già questo piano attivo.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("Piano biennale"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic biennale"),
    "plan_2_years_plus": MessageLookupByLibrary.simpleMessage("Plus biennale"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro biennale"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("Piano semestrale"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Piano mensile"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic mensile"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus mensile"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro mensile"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Piano annuale"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic annuale"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus annuale"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro annuale"),
    "poland": MessageLookupByLibrary.simpleMessage("Polonia"),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferenze"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("Vedi tutti i piani"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Informativa sulla privacy"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "Stiamo elaborando il tuo pagamento. Tutto pronto tra poco…",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "Hai già un piano attivo. Aggiorna sul web - le modifiche si sincronizzano automaticamente",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("Tutti i piani:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "L\'essenziale per la privacy di ogni giorno",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 mese"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("Annuale"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("Biennale"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("Esplora piani e funzionalità"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("Gestisci e aggiorna sul web"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "Hai già il piano più alto disponibile.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Al momento non ci sono prodotti disponibili. Riprova più tardi.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage(
      "Più dispositivi, più posizioni",
    ),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Massima protezione per utenti intensivi",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "Gli abbonamenti si gestiscono sul web. Il tuo piano si sincronizzerà con l\'app automaticamente.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("Abbonati sul web"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("Prodotti VPN"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("PROTETTO"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protocollo"),
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Cambiare il protocollo VPN ti disconnetterà. Dovrai riconnetterti in seguito.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("Cambio del protocollo VPN"),
    "pt": MessageLookupByLibrary.simpleMessage("Portoghese"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Portoghese brasiliano"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Ricevi notifiche su nuove funzionalità, consigli utili e offerte esclusive - solo aggiornamenti utili.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Resta aggiornato con le notifiche push",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notifiche push"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Aggiornamenti sui prodotti, consigli e offerte speciali",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("Com\'è la tua connessione?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("Cosa non ti è piaciuto?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("Cosa ti è piaciuto?"),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Posizioni recenti"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("Riscatta codice sconto"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Il tuo account è stato eliminato con successo. Verrai reindirizzato alla schermata di accesso.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Aggiorna"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("Aggiorna IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("Aggiorna indirizzo IP"),
    "refreshLocationsTooltip": m23,
    "renewsOn": m24,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("Ripristina quando qualcosa non funziona"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "Se procedi con il ripristino dell\'app, verrai disconnesso da Mysterium VPN.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage(
      "La connessione VPN è attualmente attiva",
    ),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "Ripristino dell\'app non riuscito. Riprova.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage(
      "L\'app è stata ripristinata correttamente.",
    ),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("Ripristina app"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Ripristina"),
    "residential": MessageLookupByLibrary.simpleMessage("Residenziale"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Sembra un utente reale",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Più difficili da rilevare",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Meno blocchi"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP RESIDENZIALI"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "Gli IP residenziali provengono da dispositivi domestici reali, facendo apparire il tuo traffico come un normale uso di internet.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage(
      "Dispositivi domestici reali",
    ),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Poiché questi IP provengono da dispositivi reali, alcuni nodi possono andare offline di tanto in tanto.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "La disponibilità può cambiare",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "Se il tuo IP attuale diventa non disponibile, l\'app ti riconnette all\'IP residenziale disponibile più vicino.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage(
      "Riconnessione automatica",
    ),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("Ho capito"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gli IP residenziali sono diversi dagli IP datacenter. Ecco cosa aspettarti.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage(
      "Come funzionano gli IP residenziali",
    ),
    "residentialIpBadge": MessageLookupByLibrary.simpleMessage("IP residenziale"),
    "resumeBtn": MessageLookupByLibrary.simpleMessage("Riprendi"),
    "resumeSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "Impossibile riprendere l\'abbonamento. Riprova.",
    ),
    "resumeSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Il tuo abbonamento riprenderà subito.",
    ),
    "resumeSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Riprendere l’abbonamento?"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Riprova"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Lascia una recensione"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "Fantastico! Ti va di lasciarci una recensione?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "Consiglieresti questa app ad altri?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Cerca posizioni"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("Vedi i piani"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage(
      "Seleziona un\'app email per continuare",
    ),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("semestrale"),
    "sendAgain": m25,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "Stiamo riscontrando problemi di rete temporanei. Riprova più tardi..",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Gestisci"),
    "settings": MessageLookupByLibrary.simpleMessage("Impostazioni"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Per usare Mysterium VPN, abbiamo bisogno della tua autorizzazione per installare un profilo VPN.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Il tuo anonimato è al sicuro. Non vediamo, raccogliamo o memorizziamo la tua attività di navigazione.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Ci serve la tua autorizzazione",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Accedi a Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Accesso interrotto"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Accedi"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN non registra le tue attività online e nessun dato è collegato a te, al tuo dispositivo, al tuo indirizzo IP o alla tua email. Accedendo, accetti i nostri",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 mesi"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Salta"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Qualcosa è andato storto. Riprova!",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Connessione stabile"),
    "status": MessageLookupByLibrary.simpleMessage("Stato"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Rimani"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("Resta nell’app"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Invia"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("Abbonati sul web"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "Ottime notizie! Il tuo abbonamento è ora attivo.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Torna ai piani"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "Confronta tutte le funzionalità",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Piano attuale"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Ottieni il piano"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Mensile"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("Annuale"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("Tutti i piani"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Aggiorna il tuo piano"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "Esplora funzionalità avanzate come i protocolli VPN e il blocco malware.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Potenzia la tua protezione",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("Salta per ora"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "Ti connetteremo al server migliore.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Connettiti per navigare in privato",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Acquista, aggiorna o visualizza i piani disponibili in base al tuo livello di accesso.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage(
      "Gestisci il tuo piano",
    ),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Sfoglia la mappa o esplora le posizioni dalla barra laterale.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Esplora le posizioni a modo tuo",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Sfoglia la mappa per scegliere un paese e connetterti all\'istante.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "Connetti dalla mappa",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Impara a orientarti nell\'app aggiornata e scopri dove si trovano ora le funzionalità principali.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage("Fai un breve tour"),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Trova rapidamente paesi, città e server con la ricerca.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Cerca e connettiti più velocemente",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Scegli una posizione per iniziare a navigare in modo più privato.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Configurazione completata",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("Inizia il tour"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Esplora paesi e città in un unico posto.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Esplora paesi, città, connessioni recenti e server specializzati in un unico posto.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "Sfoglia le posizioni VPN",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("MIGLIOR PREZZO"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("Scelta a livello di città"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Offre un controllo della posizione più preciso rispetto alla maggior parte delle VPN, che di solito ti limitano alla selezione di interi paesi o stati.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Dispositivi protetti contemporaneamente",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("Doppia VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Un ulteriore livello di sicurezza. Instrada il tuo traffico internet attraverso due server VPN diversi, crittografando i tuoi dati due volte e mascherando il tuo indirizzo IP dietro un secondo server",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("Blocco malware"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Protegge il tuo dispositivo fermando le minacce prima che lo raggiungano, lavorando silenziosamente in background senza interromperti.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "Garanzia di rimborso entro 7 giorni",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage(
      "Proteggi 6 dispositivi alla volta",
    ),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage(
      "Proteggi 10 dispositivi alla volta",
    ),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 paesi supportati"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage("Oltre 100 paesi supportati"),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 server"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 server"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("Protocollo VPN"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("Oltre 7.500 IP residenziali"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("Protocollo VPN"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("Scelta a livello di città"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("IP residenziali"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Appari come un normale utente domestico, così puoi accedere ai servizi di streaming ed evitare il rilevamento della VPN.",
    ),
    "subscriptionPlanSavePercent": m26,
    "subscriptionPlanSaveWith": m27,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Server"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage("Paesi supportati"),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("Protocollo VPN"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - protocollo veloce, ideale per gaming e streaming\nOpenVPN - protocollo altamente configurabile che funziona dove gli altri falliscono (non disponibile su Android)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "Non hai completato le modifiche al tuo abbonamento.",
    ),
    "subscriptionResumed": MessageLookupByLibrary.simpleMessage(
      "Il tuo abbonamento è di nuovo attivo.",
    ),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Aggiorna"),
    "subscriptionUpgradeCTA": m28,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "per accedere a oltre 7.500 IP residenziali",
    ),
    "subscriptionUpgradeModalTitle": m29,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("Vedi tutti i piani"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("Riprova la verifica"),
    "subscripton": MessageLookupByLibrary.simpleMessage("Abbonamento"),
    "switchToLocationBtn": m30,
    "system": MessageLookupByLibrary.simpleMessage("Sistema"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("Riprenditi internet."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Termini e Condizioni"),
    "title": MessageLookupByLibrary.simpleMessage("Ciao"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Troppe richieste. Riprova più tardi.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage("Token già utilizzato. Riprova.\n"),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Disconnetti"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("Riconnetti"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "Hai raggiunto il limite massimo di 6 dispositivi connessi al tuo account. Per continuare a usare la VPN, tocca per riconnetterti.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "Hai raggiunto il limite massimo di 6 dispositivi connessi al tuo account. Per continuare a usare la VPN, tocca disconnetti e riprova.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("Sei stato disconnesso"),
    "topLocations": MessageLookupByLibrary.simpleMessage("Posizioni principali"),
    "tr": MessageLookupByLibrary.simpleMessage("Turco"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Riprova"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage(
      "Prova a cercare un\'altra posizione",
    ),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Devi concedere l\'autorizzazione per avviare il tunnel VPN.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage(
      "Si è verificato un errore durante la configurazione del tunnel",
    ),
    "typeDelete": m31,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Scrivi qui il tuo feedback..."),
    "udpBlockedConfirm": MessageLookupByLibrary.simpleMessage("Passa a OpenVPN"),
    "udpBlockedDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard sembra bloccato su questa rete. OpenVPN si connette in modo diverso e di solito funziona qui. Passare ora?",
    ),
    "udpBlockedSwitched": MessageLookupByLibrary.simpleMessage(
      "Passato a OpenVPN. Puoi cambiarlo quando vuoi nelle Impostazioni.",
    ),
    "udpBlockedTitle": MessageLookupByLibrary.simpleMessage("Connessione WireGuard bloccata"),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ucraina"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Impossibile connettersi al processore di pagamento! Riprova.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage(
      "Non hai effettuato l\'accesso",
    ),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Accedi per gestire il tuo account e sbloccare tutte le funzionalità",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage(
      "Non hai effettuato l\'accesso",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("Annulla"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("NON PROTETTO"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Velocità instabile"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Aggiorna"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("Massima velocità"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "Connettiti al server più veloce disponibile per prestazioni ottimali",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Server specializzato"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Bassa latenza"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Si connette automaticamente al server più vicino per un accesso stabile e affidabile",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Massima privacy"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Ottieni un server con le migliori opzioni di libertà di parola e velocità in base al paese",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("Posizione più vicina"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Ti connette all\'IP VPN disponibile più vicino per velocità e prestazioni ottimali in base alla tua posizione attuale",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Scegli il server migliore per transazioni crypto sicure, condivisione file, hosting di giochi e comunicazioni",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Accedi ai tuoi programmi e film preferiti dalle piattaforme specifiche per regione",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("Vedi tutte le funzionalità"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("Vedi meno"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnDetails": MessageLookupByLibrary.simpleMessage("Dettagli VPN"),
    "vpnIp": MessageLookupByLibrary.simpleMessage("IP della VPN"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("Protocollo VPN"),
    "year": MessageLookupByLibrary.simpleMessage("anno"),
    "yearly": MessageLookupByLibrary.simpleMessage("annuale"),
    "yes": MessageLookupByLibrary.simpleMessage("Sì"),
    "zh": MessageLookupByLibrary.simpleMessage("Cinese"),
  };
}

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(store) =>
      "Tu as déjà un abonnement actif payé via ${store}. Gère-le dans ${store}.";

  static String m1(amount, period) => "${amount} /${period}";

  static String m2(amount, period) => "${amount}/mois — Facturé ${period}";

  static String m3(location) => "Se connecter à ${location}";

  static String m4(couponCode) => "${couponCode} copié dans le presse-papiers !";

  static String m5(email) => "Nous avons envoyé un e-mail à ${email}";

  static String m6(email) => "Tu as peut-être déjà un abonnement payant avec « ${email} »";

  static String m7(errorCode) => "Échec de la connexion. Réessaie [erreur : ${errorCode}]";

  static String m8(count) =>
      "${Intl.plural(count, zero: '', one: 'Pause de ${count} mois', other: 'Pause de ${count} mois')}";

  static String m9(plan) => "Choisir ${plan}";

  static String m10(plan) => "Choisir l\'offre ${plan}";

  static String m11(count) => "Réserve d\'IP : ${count}";

  static String m12(location) =>
      "Aucune autre IP n\'est disponible dans ${location}. Choisis un autre pays ou une autre ville pour obtenir une IP différente la prochaine fois.";

  static String m13(location) =>
      "Aucune autre IP n\'est disponible dans ${location}. Choisis un autre pays pour obtenir une IP différente la prochaine fois.";

  static String m14(count) =>
      "${Intl.plural(count, one: '${count} ville', other: '${count} villes')}";

  static String m15(count) => "${Intl.plural(count, one: '${count} IP', other: '${count} IP')}";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} État', other: '${count} États')}";

  static String m17(location) => "${location} n\'est pas disponible";

  static String m18(location) => "Impossible de mettre à jour ${location}";

  static String m19(location) => "${location} mis à jour";

  static String m20(date) => "Prochaine facturation : ${date}";

  static String m21(protocol, label) => "${protocol} (${label})";

  static String m22(location) => "Actualiser ${location}";

  static String m23(count) =>
      "${Intl.plural(count, one: 'Renvoyer', other: 'Renvoyer (${count})')}";

  static String m24(percent) => "Économise ${percent} %";

  static String m25(percent, planId) => "Économise ${percent} % avec une offre ${planId}";

  static String m26(plan) => "Passe à ${plan}";

  static String m27(plan) => "Passe à l\'offre ${plan}";

  static String m28(location) => "Passer à ${location}";

  static String m29(word) => "Saisis ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Connexion en cours…"),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Accepter l’offre"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Accès disponible jusqu’au :"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'accéder aux sites bloqués",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Compte"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Compte supprimé"),
    "activeSubsPaidVia": m0,
    "allLocations": MessageLookupByLibrary.simpleMessage("Tous les emplacements"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("Autoriser"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Autoriser les notifications"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage(
      "Autoriser les notifications",
    ),
    "and": MessageLookupByLibrary.simpleMessage(" et "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "La nouvelle version de l\'application est là ! Mets à jour maintenant pour profiter des dernières fonctionnalités et améliorations.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("Mise à jour disponible !"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("Mise à jour disponible"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Apparence"),
    "ar": MessageLookupByLibrary.simpleMessage("Arabe"),
    "austria": MessageLookupByLibrary.simpleMessage("Autriche"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible de se connecter. Réessaie.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Retour"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Retour aux paramètres"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("Économie de batterie"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlin, Allemagne 🇩🇪"),
    "billedInTotal": m1,
    "billedPerMonth": m2,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Bloqueur"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Mettre à jour"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Contourner les restrictions"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("Annuler"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Déconnexions"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Pannes"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Erreur 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Latence"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Fonctionnalités manquantes"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Vitesse"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Es-tu sûr de vouloir annuler ton abonnement ?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Annuler l’abonnement"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "Ton abonnement sera annulé. Tu pourras continuer à utiliser Mysterium VPN jusqu’à la fin de ton accès.",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage("Saisis plus de détails…"),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage(
      "Dis-nous en plus (facultatif)",
    ),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("Motifs d\'annulation"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Trop cher"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'accéder aux sites bloqués",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Problèmes d\'utilisabilité"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Annule ton abonnement dans les abonnements de l\'App Store avant de supprimer ton compte.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("Date d’annulation :"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "Nous ne parvenons pas à récupérer les infos de ton offre.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Infos de l\'offre indisponibles",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Récupération des infos de l\'offre…",
    ),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("Vérifie tes e-mails"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Effacer la recherche"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Fermer"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("Communications"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("COMMUNICATIONS"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Terminer"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("Confirmer l’annulation"),
    "connect": MessageLookupByLibrary.simpleMessage("Se connecter"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("Meilleur serveur"),
    "connectToLocationBtn": m3,
    "connected": MessageLookupByLibrary.simpleMessage("Connecté"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connexion en cours…"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Connexion au processeur de paiement…",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Connexion"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Connexion et protection"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Délai de connexion dépassé. Réessaie plus tard. Si le problème persiste, contacte le support",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Vitesse constante"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "Il ne fonctionne que sur l\'appareil qui l\'a demandé, appuie sur le lien dans ton e-mail pour continuer.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Continuer"),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("Continuer l’annulation"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Continuer avec Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("Continuer avec l\'e-mail"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Continuer avec Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage(
      "Copie le lien et colle-le dans ton navigateur",
    ),
    "couponCodeCopied": m4,
    "dark": MessageLookupByLibrary.simpleMessage("Sombre"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Facilement détectables"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Souvent bloquées par les sites",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Moins privées"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP DE CENTRE DE DONNÉES"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("La plupart des VPN"),
    "de": MessageLookupByLibrary.simpleMessage("Allemand"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Supprimer le compte"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("Supprimer le compte ?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Supprimer"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "Tu as atteint le nombre maximal d\'appareils connectés. Pour en ajouter un nouveau, retire-en un de ton compte.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage(
      "Ouvrir le tableau de bord",
    ),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("Limite d\'appareils atteinte"),
    "disconnect": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Déconnecté"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Déconnexion en cours…"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Seulement"),
    "dns": MessageLookupByLibrary.simpleMessage("Protection DNS"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("Empêche les fuites DNS"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Terminé"),
    "duration": MessageLookupByLibrary.simpleMessage("Durée"),
    "email": MessageLookupByLibrary.simpleMessage("Adresse e-mail"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("L\'adresse e-mail n\'est pas valide"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("L\'adresse e-mail est requise"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notifications par e-mail"),
    "emailSentTo": m5,
    "en": MessageLookupByLibrary.simpleMessage("Anglais"),
    "es": MessageLookupByLibrary.simpleMessage("Espagnol"),
    "existingSubscriptionDesc": m6,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "Tu peux te déconnecter et essayer avec ton e-mail, ou ignorer cet avertissement",
    ),
    "failedToConnectError": m7,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "Échec de l\'envoi de l\'avis. Réessaie.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Un problème est survenu avec ton abonnement. Réessaie !",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "Nous n\'avons pas pu vérifier ton dernier achat d\'abonnement. Appuie sur le bouton ci-dessous pour réessayer.",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("Rapide"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "Ta version de l\'application est obsolète. Mets-la à jour pour continuer à l\'utiliser.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Données du formulaire invalides. Vérifie les champs et réessaie.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Français"),
    "france": MessageLookupByLibrary.simpleMessage("France"),
    "freezeDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Sélectionne une durée de pause.",
    ),
    "freezeForMonths": m8,
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("Déconnexions fréquentes"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Prix plein :"),
    "germany": MessageLookupByLibrary.simpleMessage("Allemagne"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage(
      "Obtiens une nouvelle adresse IP à chaque actualisation",
    ),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Sécurise ta connexion et profite instantanément d\'une navigation privée",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("Récupération de l\'adresse IP…"),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Retour"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Aller à la connexion"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Aide et support"),
    "hi": MessageLookupByLibrary.simpleMessage("Hindi"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Masqué"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("Latence élevée"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Centre de données"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Accueil"),
    "id": MessageLookupByLibrary.simpleMessage("Indonésien"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Emplacement incorrect"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage("Lien magique incorrect. Réessaie."),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("Adresse IP"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("IP de centre de données"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "IP de centres de données optimisées pour la vitesse et la performance.",
    ),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("IP résidentielles"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Fournies par de vrais foyers. Quasi indétectables mais moins stables.",
    ),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "Les IP résidentielles sont fournies par des appareils domestiques réels, leur disponibilité peut donc varier.\n\nSi un nœud passe hors ligne, l\'application te reconnecte à l\'IP résidentielle disponible la plus proche.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "Pourquoi mon IP peut-elle changer ?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("Italien"),
    "italy": MessageLookupByLibrary.simpleMessage("Italie"),
    "ja": MessageLookupByLibrary.simpleMessage("Japonais"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Garder l’abonnement"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "Bloque le trafic Internet si la connexion VPN tombe",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Langue"),
    "light": MessageLookupByLibrary.simpleMessage("Clair"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Lien copié dans le presse-papiers !"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "Le lien expire dans 30 minutes et ne peut être utilisé qu\'une seule fois.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Emplacement"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Emplacement"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage(
      "Se connecter à l\'IP la plus proche",
    ),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "Connecte-toi à l\'IP la plus proche, ou choisis-la manuellement",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Ta session a expiré. Reconnecte-toi.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Se connecter ou s\'inscrire"),
    "logout": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "Tu es sur le point de te déconnecter. Es-tu sûr ?",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "Le VPN est activé. Tu seras déconnecté du serveur VPN si tu continues à te déconnecter.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Faible latence"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madrid, Espagne 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Malware"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Gérer sur le web"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Souhaites-tu recevoir par e-mail des mises à jour, des conseils confidentialité et des offres spéciales de Mysterium Network ?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage("Reste informé par e-mail"),
    "month": MessageLookupByLibrary.simpleMessage("mois"),
    "monthly": MessageLookupByLibrary.simpleMessage("mensuel"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Emplacements"),
    "navMap": MessageLookupByLibrary.simpleMessage("Carte"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Produits"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Prochaine date de facturation :"),
    "no": MessageLookupByLibrary.simpleMessage("Non"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("Tu n\'as aucun abonnement actif"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage(
      "Aucune application e-mail sur ton appareil.",
    ),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("Aucun emplacement trouvé"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("Aucun serveur disponible"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "Problème de connectivité, aucun serveur disponible. Réessaie plus tard.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Choisir l\'offre"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Aucune offre active disponible"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("Aucun"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("Indisponible"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Pas maintenant"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage("Pas encore prêt à annuler ?"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW et malwares"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "Ton IP et ta localisation sont visibles par les sites, les traqueurs et les réseaux Wi-Fi publics.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("Ta connexion est exposée"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN masque ton IP, ton FAI et ta localisation pour te permettre de naviguer en toute confidentialité.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Masque ta vraie identité en un geste",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "Avec les IP résidentielles, ta connexion paraît naturelle, pas comme un trafic VPN classique.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("Tous les VPN ne se valent pas"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("Ouvrir l\'application e-mail"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Ouvrir les paramètres système"),
    "or": MessageLookupByLibrary.simpleMessage("OU"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "Nous te connecterons au meilleur serveur, ou tu peux sélectionner un pays manuellement.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Autre…"),
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Mettre en pause"),
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "Tu as déjà une transaction de paiement en cours. Termine-la avant d\'en démarrer une nouvelle.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("mois"),
    "pl": MessageLookupByLibrary.simpleMessage("Polonais"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "Tout est prêt ! Tu as déjà cette offre active.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("Offre 2 ans"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 ans"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 ans"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("Offre 6 mois"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Offre mensuelle"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic mensuel"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus mensuel"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro mensuel"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Offre annuelle"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic annuel"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus annuel"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro annuel"),
    "poland": MessageLookupByLibrary.simpleMessage("Pologne"),
    "preferences": MessageLookupByLibrary.simpleMessage("Préférences"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("Voir toutes les offres"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Politique de confidentialité"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "Nous traitons ton paiement. Tout sera prêt sous peu…",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "Tu as déjà une offre active. Améliore-la sur le web, les changements se synchronisent automatiquement",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("Toutes les offres :"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "L\'essentiel pour la confidentialité au quotidien",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 mois"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 an"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 ans"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage(
      "Découvre les offres et fonctionnalités",
    ),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("Gérer et améliorer sur le web"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "Tu bénéficies déjà de l\'offre la plus élevée disponible.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Aucun produit disponible pour le moment. Réessaie plus tard.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage(
      "Plus d\'appareils, plus d\'emplacements",
    ),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Protection maximale pour les gros utilisateurs",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "Les abonnements sont gérés sur le web. Ton offre sera synchronisée automatiquement avec l\'application.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("S\'abonner sur le web"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("Produits VPN"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("PROTÉGÉ"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protocole"),
    "protocolLabel": m21,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Changer de protocole VPN te déconnectera. Tu devras te reconnecter ensuite.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage(
      "Changement de protocole VPN",
    ),
    "pt": MessageLookupByLibrary.simpleMessage("Portugais"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Portugais brésilien"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Sois informé des nouvelles fonctionnalités, des conseils utiles et des offres exclusives, rien que des mises à jour utiles.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Reste informé grâce aux notifications push",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notifications push"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Mises à jour produit, conseils et offres spéciales",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("Comment est ta connexion ?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage(
      "Qu\'est-ce qui ne t\'a pas plu ?",
    ),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("Qu\'est-ce qui t\'a plu ?"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "Tu peux réactiver ton abonnement à tout moment avant la fin de ton accès.",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Emplacements récents"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("Utiliser un code de réduction"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Ton compte a bien été supprimé. Tu vas être redirigé vers l\'écran de connexion.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Actualiser"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("Actualiser l\'IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("Actualiser l\'adresse IP"),
    "refreshLocationsTooltip": m22,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage(
      "Réinitialise quand quelque chose ne fonctionne pas",
    ),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "Si tu réinitialises l\'application, tu seras déconnecté de Mysterium VPN.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage(
      "La connexion VPN est actuellement active",
    ),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "Échec de la réinitialisation de l\'application. Réessaie.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("L\'application a été réinitialisée."),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("Réinitialiser l\'application"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Réinitialiser"),
    "residential": MessageLookupByLibrary.simpleMessage("Résidentiel"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Ressemble à un vrai utilisateur",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Plus difficiles à détecter",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage(
      "Moins de blocages",
    ),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP RÉSIDENTIELLES"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "Les IP résidentielles proviennent de vrais appareils domestiques, ce qui donne à ton trafic l\'apparence d\'une utilisation internet classique.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage(
      "Vrais appareils domestiques",
    ),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Comme ces IPs proviennent d\'appareils réels, certains nœuds peuvent se déconnecter de temps en temps.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "La disponibilité peut changer",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "Si ton IP actuelle devient indisponible, l\'application te reconnecte à l\'IP résidentielle disponible la plus proche.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage(
      "Reconnexion automatique",
    ),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("J\'ai compris"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Les IP résidentielles sont différentes des IP de centre de données. Voici à quoi t\'attendre.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage(
      "Comment fonctionnent les IP résidentielles",
    ),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Laisser un avis"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "Super ! Cela t\'ennuierait de nous laisser un avis ?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "Recommanderais-tu cette application à d\'autres ?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Rechercher des emplacements"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("Voir les offres"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage(
      "Sélectionne une application e-mail pour continuer",
    ),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("semestriel"),
    "sendAgain": m23,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "Nous rencontrons des problèmes réseau temporaires. Réessaie plus tard.",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Gérer"),
    "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Pour utiliser Mysterium VPN, nous avons besoin de ta permission pour installer un profil VPN.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Ton anonymat est protégé. Nous ne voyons, ne collectons ni ne stockons aucune de tes activités de navigation.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Nous avons besoin de ta permission",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Connecte-toi à Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Connexion interrompue"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Se connecter"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN n\'enregistre pas tes activités en ligne, et aucune donnée n\'est liée à toi, ton appareil, ton adresse IP ou ton e-mail. En te connectant, tu acceptes nos",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 mois"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Passer"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Une erreur s\'est produite. Réessaie !",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Connexion stable"),
    "status": MessageLookupByLibrary.simpleMessage("Statut"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Rester"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Envoyer"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("S\'abonner sur le web"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "Bonne nouvelle ! Ton abonnement est maintenant actif.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Retour aux offres"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "Comparer toutes les fonctionnalités",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Offre actuelle"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Choisir l\'offre"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Mensuel"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 an"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("Toutes les offres"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Améliore ton offre"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("Abonnement annulé"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "Explore des fonctionnalités avancées comme les protocoles VPN et le blocage des malwares.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Renforce ta protection",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("Plus tard"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "Nous te connecterons au meilleur serveur.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Connecte-toi pour rester privé",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Achète, améliore ou consulte les offres disponibles selon l\'accès de ton compte.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage("Gère ton offre"),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Parcours la carte ou explore les emplacements depuis la barre latérale.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Explore les emplacements à ta façon",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Parcours la carte pour choisir un pays et connecte-toi instantanément.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "Connecte-toi depuis la carte",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Familiarise-toi avec l\'application mise à jour et découvre où se trouvent désormais les fonctionnalités clés.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Fais un tour rapide",
    ),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Trouve rapidement pays, villes et serveurs grâce à la recherche.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Recherche et connecte-toi plus vite",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Choisis un emplacement pour commencer à naviguer de façon plus privée.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Configuration terminée",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage(
      "Démarrer le tour",
    ),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Explore pays et villes en un seul endroit.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Explore pays, villes, connexions récentes et serveurs spécialisés en un seul endroit.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "Parcours les emplacements VPN",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("MEILLEURE OFFRE"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage(
      "Choix au niveau de la ville",
    ),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Offre un contrôle de la localisation plus précis que la plupart des VPN, qui te limitent généralement à choisir des pays ou des États entiers.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Appareils sécurisés à la fois",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("Double VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Couche de sécurité supplémentaire. Achemine ton trafic internet via deux serveurs VPN différents, chiffrant tes données deux fois et masquant ton adresse IP derrière un second serveur",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("Bloqueur de malwares"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Protège ton appareil en stoppant les menaces avant qu\'elles ne l\'atteignent, en fonctionnant discrètement en arrière-plan sans t\'interrompre.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "Garantie satisfait ou remboursé de 7 jours",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage(
      "Sécurise 6 appareils à la fois",
    ),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage(
      "Sécurise 10 appareils à la fois",
    ),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 pays pris en charge"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage(
      "Plus de 100 pays pris en charge",
    ),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 serveurs"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 serveurs"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("Protocole VPN"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage(
      "Plus de 7 500 IP résidentielles",
    ),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("Protocole VPN"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("Choix au niveau de la ville"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("IP résidentielles"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Apparais comme un utilisateur domestique normal, ce qui te permet d\'accéder aux services de streaming et d\'éviter la détection VPN.",
    ),
    "subscriptionPlanSavePercent": m24,
    "subscriptionPlanSaveWith": m25,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Serveurs"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage(
      "Pays pris en charge",
    ),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("Protocole VPN"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - protocole rapide idéal pour le jeu et le streaming\nOpenVPN - protocole hautement configurable qui fonctionne là où les autres échouent (non disponible sur Android)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "Tu n\'as pas finalisé les modifications de ton abonnement.",
    ),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Améliorer"),
    "subscriptionUpgradeCTA": m26,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "pour accéder à plus de 7 500 IP résidentielles",
    ),
    "subscriptionUpgradeModalTitle": m27,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage(
      "Voir toutes les offres",
    ),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage(
      "Réessayer la vérification",
    ),
    "subscripton": MessageLookupByLibrary.simpleMessage("Abonnement"),
    "switchToLocationBtn": m28,
    "system": MessageLookupByLibrary.simpleMessage("Système"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage(
      "Reprends le contrôle d\'Internet.",
    ),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Conditions générales"),
    "title": MessageLookupByLibrary.simpleMessage("Bonjour"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Trop de requêtes. Réessaie plus tard.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage("Jeton déjà utilisé. Réessaie.\n"),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("Se reconnecter"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "Tu as atteint la limite de 6 appareils connectés sur ton compte. Pour continuer à utiliser le VPN, appuie pour te reconnecter.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "Tu as atteint la limite de 6 appareils connectés sur ton compte. Pour continuer à utiliser le VPN, appuie sur déconnecter et réessaie.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("Tu as été déconnecté"),
    "topLocations": MessageLookupByLibrary.simpleMessage("Meilleurs emplacements"),
    "tr": MessageLookupByLibrary.simpleMessage("Turc"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage(
      "Essaie de rechercher un autre emplacement",
    ),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Tu dois accorder l\'autorisation pour démarrer le tunnel VPN.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage(
      "Une erreur s\'est produite lors de la configuration du tunnel",
    ),
    "typeDelete": m29,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Écris ton avis ici…"),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ukraine"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Impossible de se connecter au processeur de paiement ! Réessaie.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("Tu n\'es pas connecté"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Connecte-toi pour accéder à ton compte et débloquer toutes les fonctionnalités",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("Tu n\'es pas connecté"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("NON PROTÉGÉ"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Vitesse instable"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Mettre à jour"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("Meilleure vitesse"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "Connecte-toi au serveur le plus rapide disponible pour des performances optimales",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Serveur spécialisé"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Faible latence"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Te connecte automatiquement au serveur le plus proche pour un accès stable et fiable",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Confidentialité maximale"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Obtiens un serveur offrant les meilleures options de liberté d\'expression et de vitesse selon le pays",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("Emplacement le plus proche"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Te connecte à l\'IP VPN disponible la plus proche pour la meilleure vitesse et performance selon ta position actuelle",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Choisis le meilleur serveur pour les transactions crypto sécurisées, le partage de fichiers, l\'hébergement de jeux et les communications",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Accède à tes émissions et films préférés depuis des plateformes régionales",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("Voir toutes les fonctionnalités"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("Voir moins"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("Protocole VPN"),
    "year": MessageLookupByLibrary.simpleMessage("an"),
    "yearly": MessageLookupByLibrary.simpleMessage("annuel"),
    "yes": MessageLookupByLibrary.simpleMessage("Oui"),
    "zh": MessageLookupByLibrary.simpleMessage("Chinois"),
  };
}

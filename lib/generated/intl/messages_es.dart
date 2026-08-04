// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(date) => "Acceso disponible hasta ${date}";

  static String m1(store) =>
      "Ya tienes una suscripción activa pagada mediante ${store}. Gestiónala en ${store}.";

  static String m2(amount, period) => "${amount} /${period}";

  static String m3(amount, period) => "${amount}/mes — Facturado ${period}";

  static String m4(location) => "Conectar a ${location}";

  static String m5(couponCode) => "¡${couponCode} copiado al portapapeles!";

  static String m6(email) => "Enviamos un correo a ${email}";

  static String m7(email) => "Puede que ya tengas una suscripción pagada con “${email}”";

  static String m8(errorCode) => "No se pudo conectar. Inténtalo de nuevo [error: ${errorCode}]";

  static String m9(plan) => "Obtén ${plan}";

  static String m10(plan) => "Obtener plan ${plan}";

  static String m11(count) => "Grupo de IP: ${count}";

  static String m12(location) =>
      "No hay IP alternativas disponibles en ${location}. Elige otro país o ciudad para obtener una IP distinta la próxima vez.";

  static String m13(location) =>
      "No hay IP alternativas disponibles en ${location}. Elige otro país para obtener una IP distinta la próxima vez.";

  static String m14(count) =>
      "${Intl.plural(count, one: '${count} ciudad', other: '${count} ciudades')}";

  static String m15(count) => "${Intl.plural(count, one: '${count} IP', other: '${count} IPs')}";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} estado', other: '${count} estados')}";

  static String m17(location) => "${location} no está disponible";

  static String m18(location) => "No se pudo actualizar ${location}";

  static String m19(location) => "${location} actualizado";

  static String m20(date) => "Próxima facturación: ${date}";

  static String m21(count) =>
      "${Intl.plural(count, zero: '', one: 'Pausar ${count} mes', other: 'Pausar ${count} meses')}";

  static String m22(date) => "Pausado hasta ${date}";

  static String m23(protocol, label) => "${protocol} (${label})";

  static String m24(location) => "Actualizar ${location}";

  static String m25(date) => "Se renueva el ${date}";

  static String m26(count) =>
      "${Intl.plural(count, one: 'Reenviar', other: 'Reenviar (${count})')}";

  static String m27(percent) => "Ahorra ${percent}%";

  static String m28(percent, planId) => "Ahorra ${percent}% con un plan ${planId}";

  static String m29(plan) => "Mejora a ${plan}";

  static String m30(plan) => "Mejora al plan ${plan}";

  static String m31(location) => "Cambiar a ${location}";

  static String m32(word) => "Escribe ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Iniciando sesión..."),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Aceptar oferta"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Acceso disponible hasta:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "No se puede acceder a sitios bloqueados",
    ),
    "accessUntil": m0,
    "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Cuenta eliminada"),
    "activeSubsPaidVia": m1,
    "allLocations": MessageLookupByLibrary.simpleMessage("Todas las ubicaciones"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("Permitir"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Permitir notificaciones"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("Permitir notificaciones"),
    "and": MessageLookupByLibrary.simpleMessage(" y "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "¡Ya está aquí la nueva versión de la app! Actualiza ahora para acceder a las últimas funciones y mejoras.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("¡Actualización disponible!"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("Actualización disponible"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Apariencia"),
    "ar": MessageLookupByLibrary.simpleMessage("Árabe"),
    "austria": MessageLookupByLibrary.simpleMessage("Austria"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo iniciar sesión. Inténtalo de nuevo.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Atrás"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Volver a Ajustes"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("Ahorro de batería"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlín, Alemania 🇩🇪"),
    "billedInTotal": m2,
    "billedPerMonth": m3,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Bloqueador"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Actualizar ahora"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Eludir restricciones"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Desconexiones"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Tiempos de inactividad"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Error 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Latencia"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Faltan funciones"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Velocidad"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres cancelar tu suscripción?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Cancelar suscripción"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "Tu suscripción se cancelará. Puedes seguir usando Mysterium VPN hasta que termine tu acceso.",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage("Introduce más detalles..."),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage("Cuéntanos más (opcional)"),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("Motivos de cancelación"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Demasiado caro"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "No puedo acceder a sitios bloqueados",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Problemas de usabilidad"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Cancela tu suscripción en las suscripciones de la App Store antes de eliminar tu cuenta.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("Fecha de cancelación:"),
    "cancelled": MessageLookupByLibrary.simpleMessage("Cancelada"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "No podemos recuperar la información de tu plan.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "La información del plan no está disponible",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Obteniendo información del plan...",
    ),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("Revisa tu correo"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Borrar búsqueda"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("Comunicaciones"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("COMUNICACIONES"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Completar"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("Confirmar cancelación"),
    "connect": MessageLookupByLibrary.simpleMessage("Conectar"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("Mejor servidor"),
    "connectToLocationBtn": m4,
    "connected": MessageLookupByLibrary.simpleMessage("Conectado"),
    "connectedSince": MessageLookupByLibrary.simpleMessage("Tiempo conectado"),
    "connecting": MessageLookupByLibrary.simpleMessage("Conectando"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Conectando con el procesador de pagos...",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Conexión"),
    "connectionDetails": MessageLookupByLibrary.simpleMessage("Detalles de conexión"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Conexión y protección"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Se agotó el tiempo de conexión. Inténtalo de nuevo más tarde. Si el problema persiste, contacta con el equipo de soporte",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Velocidad constante"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "Solo funciona en el dispositivo que lo solicitó: pulsa el enlace de tu correo para continuar.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Continuar"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "Te redirigiremos al sitio web de Mysterium VPN para completar la cancelación.",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "Continuar la cancelación en la web",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("Seguir con la cancelación"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("Ir al sitio web"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Continuar con Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("Continuar con correo"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Continuar con Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copia el enlace y pégalo en tu navegador"),
    "couponCodeCopied": m5,
    "dark": MessageLookupByLibrary.simpleMessage("Oscuro"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Fáciles de detectar"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Suelen bloquearlas los sitios web",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Menos privadas"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IPS DE CENTRO DE DATOS"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("La mayoría de VPN"),
    "de": MessageLookupByLibrary.simpleMessage("Alemán"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("¿Eliminar cuenta?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el número máximo de dispositivos conectados. Para añadir uno nuevo, elimina uno existente de tu cuenta.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("Abrir panel"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage(
      "Límite de dispositivos alcanzado",
    ),
    "disconnect": MessageLookupByLibrary.simpleMessage("Desconectar"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Desconectado"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Desconectando"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Solo"),
    "dns": MessageLookupByLibrary.simpleMessage("Protección DNS"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("Evita fugas de DNS"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Listo"),
    "duration": MessageLookupByLibrary.simpleMessage("Duración"),
    "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("El correo electrónico no es válido"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("El correo electrónico es obligatorio"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notificaciones por correo"),
    "emailSentTo": m6,
    "en": MessageLookupByLibrary.simpleMessage("Inglés"),
    "es": MessageLookupByLibrary.simpleMessage("Español"),
    "existingSubscriptionDesc": m7,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "Puedes cerrar sesión e intentarlo con tu correo o ignorar este aviso",
    ),
    "failedToConnectError": m8,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "No se pudieron enviar los comentarios. Inténtalo de nuevo.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal con tu suscripción. ¡Inténtalo de nuevo!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "No pudimos verificar tu última compra de suscripción. Toca el botón de abajo para reintentar.",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("Rápido"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "Tu versión de la app está desactualizada. Actualízala para seguir usándola.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Datos del formulario no válidos. Revisa los campos e inténtalo de nuevo.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Francés"),
    "france": MessageLookupByLibrary.simpleMessage("Francia"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("Desconexiones frecuentes"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Precio completo:"),
    "germany": MessageLookupByLibrary.simpleMessage("Alemania"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage(
      "Consigue una nueva dirección IP al actualizar",
    ),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Protege tu conexión y disfruta de la navegación privada al instante",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("Obteniendo dirección IP..."),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Volver"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Ir a iniciar sesión"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Ayuda y soporte"),
    "hi": MessageLookupByLibrary.simpleMessage("Hindi"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Oculto"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("Alta latencia"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Centro de datos"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Inicio"),
    "id": MessageLookupByLibrary.simpleMessage("Indonesio"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Ubicación incorrecta"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage(
      "Enlace mágico incorrecto. Inténtalo de nuevo.",
    ),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("Dirección IP"),
    "ipDetails": MessageLookupByLibrary.simpleMessage("Detalles de IP"),
    "ipPool": MessageLookupByLibrary.simpleMessage("Pool de IP"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipType": MessageLookupByLibrary.simpleMessage("Tipo de IP"),
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("IP de centro de datos"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "IP de centro de datos optimizadas para velocidad y rendimiento.",
    ),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("IP residenciales"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Proporcionadas por hogares reales. Casi indetectables, pero menos estables.",
    ),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "Las IP residenciales las proporcionan dispositivos domésticos reales, por lo que la disponibilidad puede cambiar con el tiempo.\n\nSi un nodo se desconecta, la app te reconecta a la IP residencial disponible más cercana.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "¿Por qué puede cambiar mi IP?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("Italiano"),
    "italy": MessageLookupByLibrary.simpleMessage("Italia"),
    "ja": MessageLookupByLibrary.simpleMessage("Japonés"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Mantener suscripción"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "Bloquea el tráfico de internet si se cae la conexión VPN",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Idioma"),
    "light": MessageLookupByLibrary.simpleMessage("Claro"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("¡Enlace copiado al portapapeles!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "El enlace caduca en 30 minutos y solo se puede usar una vez.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Ubicación"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Ubicación"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage(
      "Conectar a la IP más cercana",
    ),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "Conéctate a la IP más cercana o elígela manualmente",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Tu sesión ha caducado. Inicia sesión de nuevo.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Inicia sesión o regístrate"),
    "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "Estás a punto de cerrar sesión. ¿Seguro?",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "La VPN está activada. Se te desconectará del servidor VPN si continúas cerrando sesión.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Baja latencia"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madrid, España 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Malware"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Gestionar en la web"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "¿Quieres recibir novedades por correo, consejos de privacidad y ofertas especiales de Mysterium Network?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Mantente al día por correo",
    ),
    "month": MessageLookupByLibrary.simpleMessage("mes"),
    "monthly": MessageLookupByLibrary.simpleMessage("mensual"),
    "myIp": MessageLookupByLibrary.simpleMessage("Mi IP"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Ubicaciones"),
    "navMap": MessageLookupByLibrary.simpleMessage("Mapa"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Productos"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Próxima fecha de cobro:"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage(
      "No tienes ninguna suscripción activa",
    ),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("No hay apps de correo en tu dispositivo."),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("No se encontraron ubicaciones"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("No hay servidores disponibles"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "Hay un problema de conexión y no hay servidores disponibles. Inténtalo más tarde.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Obtener plan"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "No hay ningún plan activo disponible",
    ),
    "noneLbl": MessageLookupByLibrary.simpleMessage("Ninguno"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("No disponible"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Ahora no"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage("¿Aún no quieres cancelar?"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW y malware"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "Tu IP y tu ubicación son visibles para sitios web, rastreadores y redes Wi-Fi públicas.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("Tu conexión está expuesta"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN oculta tu IP, tu proveedor y tu ubicación para que navegues con privacidad real.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Oculta tu identidad real con un toque",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "Con IP residenciales, tu conexión parece natural, no como el tráfico típico de VPN.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage(
      "No todas las VPN funcionan igual",
    ),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("Abrir app de correo"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Abrir ajustes del sistema"),
    "optional": MessageLookupByLibrary.simpleMessage("opcional"),
    "or": MessageLookupByLibrary.simpleMessage("O"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "Te conectaremos al mejor servidor, o puedes elegir un país manualmente.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Otro..."),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Selecciona una duración de la pausa.",
    ),
    "pauseForMonths": m21,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Pausar suscripción"),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Puedes pausar tu plan una vez por ciclo de facturación.",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("Pausada"),
    "pausedUntil": m22,
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "Ya tienes una transacción de pago en curso. Complétala antes de iniciar una nueva.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("mes"),
    "pl": MessageLookupByLibrary.simpleMessage("Polaco"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "¡Listo! Ya tienes este plan activo.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("Plan de 2 años"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 años"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 años"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("Plan de 6 meses"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Plan mensual"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic mensual"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus mensual"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro mensual"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Plan anual"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic anual"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus anual"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro anual"),
    "poland": MessageLookupByLibrary.simpleMessage("Polonia"),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferencias"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("Ver todos los planes"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Política de privacidad"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "Estamos procesando tu pago. Todo estará listo en breve…",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "Ya tienes un plan activo. Mejora en la web: los cambios se sincronizan automáticamente",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("Todos los planes:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "Lo esencial para la privacidad diaria",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 mes"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 año"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 años"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("Explora planes y funciones"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("Gestiona y mejora en la web"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "Ya tienes el plan más alto disponible.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "No hay productos disponibles en este momento. Inténtalo de nuevo más tarde.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage(
      "Más dispositivos, más ubicaciones",
    ),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Máxima protección para usuarios intensivos",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "Las suscripciones se gestionan en la web. Tu plan se sincronizará con la app automáticamente.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("Suscríbete en la web"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("Productos VPN"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("PROTEGIDO"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protocolo"),
    "protocolLabel": m23,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Cambiar el protocolo VPN te desconectará. Tendrás que volver a conectarte después.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("Cambio de protocolo VPN"),
    "pt": MessageLookupByLibrary.simpleMessage("Portugués"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Portugués brasileño"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Recibe avisos sobre nuevas funciones, consejos útiles y ofertas exclusivas: solo novedades útiles.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Mantente al día con las notificaciones push",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notificaciones push"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Novedades de producto, consejos y ofertas especiales",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("¿Cómo está tu conexión?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("¿Qué no te gustó?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("¿Qué te gustó?"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "Puedes reactivar tu suscripción en cualquier momento antes de que termine tu acceso.",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Ubicaciones recientes"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("Canjear código de descuento"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Tu cuenta se ha eliminado correctamente. Te redirigiremos a la pantalla de inicio de sesión.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("Actualizar IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("Actualizar dirección IP"),
    "refreshLocationsTooltip": m24,
    "renewsOn": m25,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("Restablece cuando algo no funcione"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "Si continúas restableciendo la app, se te desconectará de Mysterium VPN.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage("La conexión VPN está activa"),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo restablecer la app. Inténtalo de nuevo.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage(
      "La app se ha restablecido correctamente.",
    ),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("Restablecer app"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Restablecer"),
    "residential": MessageLookupByLibrary.simpleMessage("Residencial"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Parece un usuario real",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Más difíciles de detectar",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Menos bloqueos"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP RESIDENCIALES"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "Las IP residenciales provienen de dispositivos domésticos reales, lo que hace que tu tráfico parezca un uso normal de internet.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage(
      "Dispositivos domésticos reales",
    ),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Como estas IPs provienen de dispositivos reales, algunos nodos pueden desconectarse de vez en cuando.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "La disponibilidad puede cambiar",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "Si tu IP actual deja de estar disponible, la app te reconecta a la IP residencial disponible más cercana.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage(
      "Reconexión automática",
    ),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("Entendido"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Las IP residenciales son distintas de las IP de centro de datos. Esto es lo que puedes esperar.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage(
      "Cómo funcionan las IP residenciales",
    ),
    "resumeBtn": MessageLookupByLibrary.simpleMessage("Reanudar"),
    "resumeSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Tu suscripción se reanudará de inmediato.",
    ),
    "resumeSubscriptionTitle": MessageLookupByLibrary.simpleMessage("¿Reanudar suscripción?"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Dejar una reseña"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "¡Genial! ¿Te importaría dejarnos una reseña?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "¿Recomendarías esta app a otras personas?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Buscar ubicaciones"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("Ver planes"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage(
      "Elige una app de correo para continuar",
    ),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("semestral"),
    "sendAgain": m26,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "Estamos teniendo problemas temporales de red. Inténtalo de nuevo más tarde..",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Gestionar"),
    "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Para usar Mysterium VPN, necesitamos tu permiso para instalar un perfil de VPN.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Tu anonimato está a salvo. No vemos, recopilamos ni almacenamos nada de tu actividad de navegación.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Necesitamos tu permiso",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Inicia sesión en Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Inicio de sesión cancelado"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN no registra tus actividades en línea, y ningún registro se vincula contigo, tu dispositivo, tu dirección IP ni tu correo. Al iniciar sesión, aceptas nuestros",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 meses"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Omitir"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal. ¡Inténtalo de nuevo!",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Conexión estable"),
    "status": MessageLookupByLibrary.simpleMessage("Estado"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Quedarme"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("Quedarme en la app"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Enviar"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("Suscríbete en la web"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "¡Buenas noticias! Tu suscripción ya está activa.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Volver a los planes"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "Comparar todas las funciones",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Plan actual"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Obtener plan"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Mensual"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 año"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("Todos los planes"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Mejora tu plan"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("Suscripción cancelada"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "Descubre funciones avanzadas como los protocolos VPN y el bloqueo de malware.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Refuerza tu protección",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("Ahora no"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "Te conectaremos al mejor servidor.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Conéctate para mantener tu privacidad",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Compra, mejora o consulta los planes disponibles según el acceso de tu cuenta.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage(
      "Gestiona tu plan",
    ),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Navega por el mapa o explora las ubicaciones desde la barra lateral.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Explora las ubicaciones a tu manera",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Navega por el mapa para elegir un país y conectarte al instante.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "Conecta desde el mapa",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Familiarízate con la app actualizada y descubre dónde están ahora las funciones clave.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Haz un recorrido rápido",
    ),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Encuentra rápido países, ciudades y servidores con la búsqueda.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Busca y conéctate más rápido",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Elige una ubicación para empezar a navegar de forma más privada.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Configuración completa",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage(
      "Iniciar recorrido",
    ),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Explora países y ciudades en un solo lugar.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Explora países, ciudades, conexiones recientes y servidores especializados en un solo lugar.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "Explora las ubicaciones de VPN",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("MEJOR PRECIO"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("Opciones a nivel de ciudad"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Ofrece un control de ubicación más preciso que la mayoría de VPN, que suelen limitarte a elegir países o estados enteros.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Dispositivos protegidos a la vez",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("Doble VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Capa extra de seguridad. Enruta tu tráfico de internet a través de dos servidores VPN distintos, cifrando tus datos dos veces y ocultando tu dirección IP tras un segundo servidor",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("Bloqueador de malware"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Protege tu dispositivo deteniendo las amenazas antes de que lleguen a él, funcionando en segundo plano sin interrumpirte.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "Garantía de devolución de 7 días",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage(
      "Protege 6 dispositivos a la vez",
    ),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage(
      "Protege 10 dispositivos a la vez",
    ),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 países compatibles"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage(
      "Más de 100 países compatibles",
    ),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 servidores"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 servidores"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("Protocolo VPN"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage(
      "Más de 7.500 IP residenciales",
    ),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("Protocolo VPN"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("Opciones a nivel de ciudad"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("IP residenciales"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Aparece como un usuario doméstico normal, para que puedas acceder a servicios de streaming y evitar la detección de VPN.",
    ),
    "subscriptionPlanSavePercent": m27,
    "subscriptionPlanSaveWith": m28,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Servidores"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage(
      "Países compatibles",
    ),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("Protocolo VPN"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard: protocolo rápido, ideal para juegos y streaming\nOpenVPN: protocolo muy configurable que funciona donde otros fallan (no disponible en Android)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "No completaste los cambios en tu suscripción.",
    ),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Mejorar"),
    "subscriptionUpgradeCTA": m29,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "para acceder a más de 7.500 IP residenciales",
    ),
    "subscriptionUpgradeModalTitle": m30,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("Ver todos los planes"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage(
      "Reintentar verificación",
    ),
    "subscripton": MessageLookupByLibrary.simpleMessage("Suscripción"),
    "switchToLocationBtn": m31,
    "system": MessageLookupByLibrary.simpleMessage("Sistema"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("Recupera internet."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Términos y condiciones"),
    "title": MessageLookupByLibrary.simpleMessage("Hola"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Demasiadas solicitudes. Inténtalo de nuevo más tarde.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage(
      "Token ya utilizado. Inténtalo de nuevo.\n",
    ),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Desconectar"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("Reconectar"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite máximo de 6 dispositivos conectados en tu cuenta. Para seguir usando la VPN, pulsa para reconectar.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el límite máximo de 6 dispositivos conectados en tu cuenta. Para seguir usando la VPN, pulsa desconectar e inténtalo de nuevo.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("Se te ha desconectado"),
    "topLocations": MessageLookupByLibrary.simpleMessage("Ubicaciones principales"),
    "tr": MessageLookupByLibrary.simpleMessage("Turco"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage("Prueba a buscar otra ubicación"),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Debes conceder permiso para iniciar el túnel VPN.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage(
      "Ocurrió un error al configurar el túnel",
    ),
    "typeDelete": m32,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Escribe tus comentarios aquí..."),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ucrania"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "¡No se pudo conectar con el procesador de pagos! Inténtalo de nuevo.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("No has iniciado sesión"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Inicia sesión para acceder a tu cuenta y desbloquear todas las funciones",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("No has iniciado sesión"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("DESPROTEGIDO"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Velocidad inestable"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("Mejor velocidad"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "Conéctate al servidor más rápido disponible para un rendimiento óptimo",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Servidor especializado"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Baja latencia"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Te conecta automáticamente al servidor más cercano para un acceso estable y fiable",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Máxima privacidad"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Consigue un servidor con las mejores opciones de libertad de expresión y velocidad según el país",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("Ubicación más cercana"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Te conecta a la IP de VPN disponible más cercana para la mejor velocidad y rendimiento según tu ubicación actual",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Elige el mejor servidor para transacciones cripto seguras, compartir archivos, alojar juegos y comunicaciones",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Accede a tus series y películas favoritas desde plataformas específicas de cada región",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("Ver todas las funciones"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("Ver menos"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnDetails": MessageLookupByLibrary.simpleMessage("Detalles de VPN"),
    "vpnIp": MessageLookupByLibrary.simpleMessage("IP de VPN"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("Protocolo VPN"),
    "year": MessageLookupByLibrary.simpleMessage("año"),
    "yearly": MessageLookupByLibrary.simpleMessage("anual"),
    "yes": MessageLookupByLibrary.simpleMessage("Sí"),
    "zh": MessageLookupByLibrary.simpleMessage("Chino"),
  };
}

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
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
  String get localeName => 'pt';

  static String m0(store) =>
      "Você já tem uma assinatura ativa paga via ${store}. Gerencie em ${store}.";

  static String m1(amount, period) => "${amount} /${period}";

  static String m2(amount, period) => "${amount}/mês — Cobrado ${period}";

  static String m3(location) => "Conectar a ${location}";

  static String m4(couponCode) => "${couponCode} copiado para a área de transferência!";

  static String m5(email) => "Enviamos um e-mail para ${email}";

  static String m6(email) => "Talvez você já tenha uma assinatura paga com “${email}”";

  static String m7(errorCode) => "Falha ao conectar. Tente novamente [error: ${errorCode}]";

  static String m8(count) =>
      "${Intl.plural(count, zero: '', one: 'Pausar por ${count} mês', other: 'Pausar por ${count} meses')}";

  static String m9(plan) => "Obter ${plan}";

  static String m10(plan) => "Obter plano ${plan}";

  static String m11(count) => "Conjunto de IP: ${count}";

  static String m12(location) =>
      "Não existem IPs alternativos disponíveis em ${location}. Escolhe outro país ou cidade para obteres um IP diferente da próxima vez.";

  static String m13(location) =>
      "Não há IPs alternativos disponíveis em ${location}. Escolhe outro país para obter um IP diferente na próxima vez.";

  static String m14(count) =>
      "${Intl.plural(count, one: '${count} Cidade', other: '${count} Cidades')}";

  static String m15(count) => "${Intl.plural(count, one: '${count} IP', other: '${count} IPs')}";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} Estado', other: '${count} Estados')}";

  static String m17(location) => "${location} não está disponível";

  static String m18(location) => "Não foi possível atualizar ${location}";

  static String m19(location) => "${location} atualizado";

  static String m20(date) => "Próxima cobrança: ${date}";

  static String m21(protocol, label) => "${protocol} (${label})";

  static String m22(location) => "Atualizar ${location}";

  static String m23(count) =>
      "${Intl.plural(count, one: 'Enviar novamente', other: 'Enviar novamente (${count})')}";

  static String m24(percent) => "Economize ${percent}%";

  static String m25(percent, planId) => "Economize ${percent}% com um plano ${planId}";

  static String m26(plan) => "Faça upgrade para ${plan}";

  static String m27(plan) => "Faça upgrade para o plano ${plan}";

  static String m28(location) => "Mudar para ${location}";

  static String m29(word) => "Digite ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Entrando..."),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Aceitar oferta"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Acesso disponível até:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "Não é possível acessar sites bloqueados",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Conta"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Conta excluída"),
    "activeSubsPaidVia": m0,
    "allLocations": MessageLookupByLibrary.simpleMessage("Todos os locais"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("Permitir"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Permitir notificações"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("Permitir notificações"),
    "and": MessageLookupByLibrary.simpleMessage(" e "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "A nova versão do app chegou! Atualize agora para os recursos e melhorias mais recentes.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage(
      "Atualização do app disponível!",
    ),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage(
      "Atualização do app disponível",
    ),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Aparência"),
    "ar": MessageLookupByLibrary.simpleMessage("Árabe"),
    "austria": MessageLookupByLibrary.simpleMessage("Áustria"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "Não foi possível entrar. Tente novamente.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Voltar"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Voltar às configurações"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("Economia de bateria"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlim, Alemanha 🇩🇪"),
    "billedInTotal": m1,
    "billedPerMonth": m2,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Bloqueador"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Atualizar agora"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Ignorar restrições"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Desconexões"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Tempos de inatividade"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Erro 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Latência"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Recursos ausentes"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Velocidade"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Tens a certeza de que queres cancelar a tua subscrição?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Cancelar subscrição"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "A tua subscrição será cancelada. Podes continuar a usar o Mysterium VPN até o teu acesso terminar.",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage("Informe mais detalhes..."),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage("Conta-nos mais (opcional)"),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("Motivos do cancelamento"),
    "cancelSurveyTitleOptional": MessageLookupByLibrary.simpleMessage(
      "Motivos do cancelamento (opcional)",
    ),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Muito caro"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "Não consigo acessar sites bloqueados",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Problemas de usabilidade"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Cancele sua assinatura na App Store antes de excluir sua conta.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("Data de cancelamento:"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "Não conseguimos recuperar as informações do seu plano.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Informações do plano indisponíveis",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage("Obtendo informações do plano..."),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("Verifique seu e-mail"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Limpar busca"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Fechar"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("Comunicações"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("COMUNICAÇÕES"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Concluir"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("Confirmar cancelamento"),
    "connect": MessageLookupByLibrary.simpleMessage("Conectar"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("Melhor servidor"),
    "connectToLocationBtn": m3,
    "connected": MessageLookupByLibrary.simpleMessage("Conectado"),
    "connecting": MessageLookupByLibrary.simpleMessage("Conectando"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Conectando ao processador de pagamento...",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Conexão"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Conexão e proteção"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Tempo de conexão esgotado. Tente novamente mais tarde. Se o problema persistir, contate o suporte",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Velocidade consistente"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "Só funciona no dispositivo que fez a solicitação - clique no link do seu e-mail para continuar.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Continuar"),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("Continuar a cancelar"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Continuar com Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("Continuar com e-mail"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Continuar com Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copie o link e cole no seu navegador"),
    "couponCodeCopied": m4,
    "dark": MessageLookupByLibrary.simpleMessage("Escuro"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Fáceis de detectar"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Muitas vezes bloqueados por sites",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Menos privados"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IPS DE DATA CENTER"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("Maioria das VPNs"),
    "de": MessageLookupByLibrary.simpleMessage("Alemão"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Excluir conta"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("Excluir conta?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Excluir"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "Você atingiu o número máximo de dispositivos conectados. Para adicionar um novo, remova um dispositivo existente da sua conta.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("Abrir painel"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage(
      "Limite de dispositivos atingido",
    ),
    "disconnect": MessageLookupByLibrary.simpleMessage("Desconectar"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Desconectado"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Desconectando"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Apenas"),
    "dns": MessageLookupByLibrary.simpleMessage("Proteção DNS"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("Evita vazamentos de DNS"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Concluído"),
    "duration": MessageLookupByLibrary.simpleMessage("Duração"),
    "email": MessageLookupByLibrary.simpleMessage("Endereço de e-mail"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("Endereço de e-mail inválido"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("Endereço de e-mail é obrigatório"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notificações por e-mail"),
    "emailSentTo": m5,
    "en": MessageLookupByLibrary.simpleMessage("Inglês"),
    "es": MessageLookupByLibrary.simpleMessage("Espanhol"),
    "existingSubscriptionDesc": m6,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "Você pode sair e tentar com seu e-mail ou ignorar este aviso",
    ),
    "failedToConnectError": m7,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "Falha ao enviar feedback. Tente novamente.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Algo deu errado com sua assinatura. Tente novamente!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "Não conseguimos verificar sua última compra de assinatura. Toque no botão abaixo para tentar de novo.",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("Rápido"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "Sua versão do app está desatualizada. Atualize o app para continuar usando.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Dados do formulário inválidos. Verifique os campos e tente novamente.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Francês"),
    "france": MessageLookupByLibrary.simpleMessage("França"),
    "freezeDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Seleciona uma duração de pausa.",
    ),
    "freezeForMonths": m8,
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("Desconexões frequentes"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Preço integral:"),
    "germany": MessageLookupByLibrary.simpleMessage("Alemanha"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage(
      "Obtenha um novo endereço IP ao atualizar",
    ),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Proteja sua conexão e aproveite a navegação privada na hora",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("Obtendo endereço IP..."),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Voltar"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Ir para login"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Ajuda e suporte"),
    "hi": MessageLookupByLibrary.simpleMessage("Hindi"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Oculto"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("Alta latência"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Início"),
    "id": MessageLookupByLibrary.simpleMessage("Indonésio"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Localização incorreta"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage(
      "Link mágico incorreto. Tente novamente.",
    ),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("Endereço IP"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("IPs de datacenter"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "IPs de datacenter otimizados para velocidade e desempenho.",
    ),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("IPs residenciais"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Fornecidos por residências reais. Quase indetectáveis, mas menos estáveis.",
    ),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "IPs residenciais são fornecidos por dispositivos domésticos reais, então a disponibilidade pode mudar com o tempo.\n\nSe um nó fica offline, o app reconecta você ao IP residencial disponível mais próximo.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "Por que meu IP pode mudar?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("Italiano"),
    "italy": MessageLookupByLibrary.simpleMessage("Itália"),
    "ja": MessageLookupByLibrary.simpleMessage("Japonês"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Manter subscrição"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "Bloqueia o tráfego de internet se a conexão VPN cair",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Idioma"),
    "light": MessageLookupByLibrary.simpleMessage("Claro"),
    "linkCopied": MessageLookupByLibrary.simpleMessage(
      "Link copiado para a área de transferência!",
    ),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "O link expira em 30 minutos e só pode ser usado uma vez.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Localização"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Localização"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage(
      "Conectar ao IP mais próximo",
    ),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "Conecte-se ao IP mais próximo - ou escolha manualmente",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Sua sessão expirou. Entre novamente.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Entrar ou cadastrar"),
    "logout": MessageLookupByLibrary.simpleMessage("Sair"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "Você está prestes a sair. Tem certeza?",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Sair"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "A VPN está ativada. Você será desconectado do servidor VPN se continuar o logout.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Baixa latência"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madri, Espanha 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Malware"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Gerenciar na web"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Deseja receber novidades por e-mail, dicas de privacidade e ofertas especiais da Mysterium Network?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Fique por dentro por e-mail",
    ),
    "month": MessageLookupByLibrary.simpleMessage("mês"),
    "monthly": MessageLookupByLibrary.simpleMessage("mensal"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Locais"),
    "navMap": MessageLookupByLibrary.simpleMessage("Mapa"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Produtos"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Próxima data de faturação:"),
    "no": MessageLookupByLibrary.simpleMessage("Não"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("Você não tem assinatura ativa"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("Não há apps de e-mail no seu dispositivo."),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("Nenhum local encontrado"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("Nenhum servidor disponível"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "Há um problema de conectividade e nenhum servidor está disponível. Tente mais tarde.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Obter plano"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Nenhum plano ativo disponível"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("Nenhum"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("Indisponível"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Agora não"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage("Ainda não queres cancelar?"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW e Malware"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "Seu IP e sua localização ficam visíveis a sites, rastreadores e redes Wi-Fi públicas.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("Sua conexão está exposta"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "A Mysterium VPN mascara seu IP, provedor e localização para você navegar com privacidade real.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Oculte sua identidade real com um toque",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "Com IPs residenciais, sua conexão parece natural - não como tráfego típico de VPN.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("Nem toda VPN funciona igual"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("Abrir app de e-mail"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Abrir configurações do sistema"),
    "or": MessageLookupByLibrary.simpleMessage("OU"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "Vamos conectar você ao melhor servidor - ou você pode selecionar um país manualmente.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Outro..."),
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Pausar subscrição"),
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "Você já tem uma transação de pagamento em andamento. Conclua-a antes de iniciar uma nova.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("mês"),
    "pl": MessageLookupByLibrary.simpleMessage("Polaco"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "Tudo pronto! Você já tem este plano ativo.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("Plano de 2 anos"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 anos"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 anos"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("Plano de 6 meses"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Plano mensal"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic mensal"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus mensal"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro mensal"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Plano anual"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic anual"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus anual"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro anual"),
    "poland": MessageLookupByLibrary.simpleMessage("Polônia"),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferências"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("Ver todos os planos"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Política de Privacidade"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "Estamos processando seu pagamento. Em breve tudo estará pronto...",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "Você já tem um plano ativo. Faça upgrade na web - as alterações sincronizam automaticamente",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("Todos os planos:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "O essencial para a privacidade do dia a dia",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 mês"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 ano"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 anos"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("Explore planos e recursos"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage(
      "Gerencie e faça upgrade na web",
    ),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "Você já está no plano mais completo disponível.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Não há produtos disponíveis no momento. Tente novamente mais tarde.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage(
      "Mais dispositivos, mais locais",
    ),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Proteção máxima para usuários intensivos",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "As assinaturas são gerenciadas na web. Seu plano sincroniza automaticamente com o app.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("Assine na web"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("Produtos VPN"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("PROTEGIDO"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protocolo"),
    "protocolLabel": m21,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Trocar o protocolo VPN vai desconectar você. Você precisará reconectar depois.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("Trocar protocolo VPN"),
    "pt": MessageLookupByLibrary.simpleMessage("Português"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Português do Brasil"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Receba avisos sobre novos recursos, dicas úteis e ofertas exclusivas - só atualizações úteis.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Fique por dentro com notificações push",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notificações push"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Novidades de produto, dicas e ofertas especiais",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("Como está sua conexão?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("Do que você não gostou?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("Do que você gostou?"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "Podes reativar a tua subscrição a qualquer momento antes do teu acesso terminar.",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Locais recentes"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("Resgatar código de desconto"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Sua conta foi excluída com sucesso. Você será redirecionado para a tela de login.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Atualizar"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("Atualizar IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("Atualizar endereço IP"),
    "refreshLocationsTooltip": m22,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage(
      "Redefina quando algo não estiver funcionando",
    ),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "Se você prosseguir com a redefinição do app, será desconectado da Mysterium VPN.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage("A conexão VPN está ativa"),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "Falha ao redefinir o app. Tente novamente.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("O app foi redefinido com sucesso."),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("Redefinir app"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Redefinir"),
    "residential": MessageLookupByLibrary.simpleMessage("Residencial"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Parece um usuário real",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Mais difíceis de detectar",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Menos bloqueios"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IPS RESIDENCIAIS"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "IPs residenciais provêm de dispositivos domésticos reais, simulando tráfego normal da Internet.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage(
      "Dispositivos domésticos reais",
    ),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Como estes IPs vêm de dispositivos reais, alguns podem ficar offline ocasionalmente.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "A disponibilidade pode mudar",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "Se o IP atual ficar indisponível, a app reconeta-te automaticamente ao IP residencial disponível mais próximo.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage("Reconexão automática"),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("Entendi"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "IPs residenciais são diferentes dos IPs de datacenter. Veja o que esperar.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage(
      "Como funcionam os IPs residenciais",
    ),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Tentar de novo"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Deixar uma avaliação"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "Ótimo! Gostarias de deixar uma avaliação?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "Recomendaria este app a outras pessoas?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Buscar locais"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("Ver planos"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage(
      "Selecione o app de e-mail para continuar",
    ),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("semestralmente"),
    "sendAgain": m23,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "Estamos com problemas temporários de rede. Tente novamente mais tarde.",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Gerenciar"),
    "settings": MessageLookupByLibrary.simpleMessage("Configurações"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Para usar a Mysterium VPN, precisamos da sua permissão para instalar um perfil VPN.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Seu anonimato está seguro. Não vemos, coletamos ou armazenamos nenhuma atividade de navegação sua.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Precisamos da sua permissão",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Entre na Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Login cancelado"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Entrar"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "A Mysterium VPN não registra suas atividades online, e nenhum registro fica vinculado a você, seu dispositivo, seu IP ou seu e-mail. Ao entrar, você concorda com nossos",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 meses"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Pular"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage("Algo deu errado. Tente novamente!"),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Conexão estável"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Ficar"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Enviar"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("Assinar na web"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "Ótima notícia! Sua assinatura já está ativa.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Voltar aos planos"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "Comparar todos os recursos",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Plano atual"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Obter plano"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Mensal"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 ano"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("Todos os planos"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Faça upgrade do plano"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("Subscrição cancelada"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "Explore recursos avançados como protocolos VPN e bloqueio de malware.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Reforce sua proteção",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage(
      "Pular por agora",
    ),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "Vamos conectar você ao melhor servidor.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Conecte-se para se manter privado",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Compre, faça upgrade ou veja os planos disponíveis conforme o acesso da sua conta.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage(
      "Gerencie seu plano",
    ),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Navegue pelo mapa ou explore locais na barra lateral.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Explore locais do seu jeito",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Navegue pelo mapa para escolher um país e conectar na hora.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "Conecte-se pelo mapa",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Conheça o app atualizado e descubra onde ficam os principais recursos agora.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage(
      "Faça um tour rápido",
    ),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Encontre rapidamente países, cidades e servidores com a busca.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Busque e conecte mais rápido",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Escolha um local para começar a navegar com mais privacidade.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Configuração concluída",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("Iniciar tour"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Explore países e cidades em um só lugar.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Explore países, cidades, conexões recentes e servidores especiais em um só lugar.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "Explore locais de VPN",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("MELHOR CUSTO-BENEFÍCIO"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("Opções em nível de cidade"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Oferece controle de localização mais preciso do que a maioria das VPNs, que normalmente limitam você a escolher países ou estados inteiros.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Dispositivos protegidos de uma vez",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("VPN dupla"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Camada extra de segurança. Roteia seu tráfego de internet por dois servidores VPN diferentes, criptografando seus dados duas vezes e mascarando seu IP atrás de um segundo servidor",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("Bloqueador de malware"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Protege seu dispositivo bloqueando ameaças antes que elas o alcancem, rodando discretamente em segundo plano sem interromper você.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "Garantia de reembolso de 7 dias",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage(
      "Proteja 6 dispositivos ao mesmo tempo",
    ),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage(
      "Proteja 10 dispositivos ao mesmo tempo",
    ),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 países suportados"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage(
      "Mais de 100 países suportados",
    ),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 servidores"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 servidores"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("Protocolo VPN"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage(
      "Mais de 7.500 IPs residenciais",
    ),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("Protocolo VPN"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("Opções em nível de cidade"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("IPs residenciais"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Apareça como um usuário doméstico comum, permitindo acessar serviços de streaming e evitar a detecção de VPN.",
    ),
    "subscriptionPlanSavePercent": m24,
    "subscriptionPlanSaveWith": m25,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Servidores"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage("Países suportados"),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("Protocolo VPN"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - protocolo rápido, ideal para jogos e streaming\nOpenVPN - protocolo altamente configurável que funciona onde outros falham (indisponível no Android)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "Você não concluiu as alterações na sua assinatura.",
    ),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Upgrade"),
    "subscriptionUpgradeCTA": m26,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "para acessar mais de 7.500 IPs residenciais",
    ),
    "subscriptionUpgradeModalTitle": m27,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("Ver todos os planos"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("Repetir verificação"),
    "subscripton": MessageLookupByLibrary.simpleMessage("Assinatura"),
    "switchToLocationBtn": m28,
    "system": MessageLookupByLibrary.simpleMessage("Sistema"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("Retome a internet."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Termos e Condições"),
    "title": MessageLookupByLibrary.simpleMessage("Olá"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Muitas solicitações. Tente novamente mais tarde.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage(
      "Token já utilizado. Tente novamente.\n",
    ),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Desconectar"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("Reconectar"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "Você atingiu o limite máximo de 6 dispositivos conectados na sua conta. Para continuar usando a VPN, toque para reconectar.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "Você atingiu o limite máximo de 6 dispositivos conectados na sua conta. Para continuar usando a VPN, toque em desconectar e tente novamente.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("Você foi desconectado"),
    "topLocations": MessageLookupByLibrary.simpleMessage("Locais principais"),
    "tr": MessageLookupByLibrary.simpleMessage("Turco"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Tentar novamente"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage("Tente buscar outro local"),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Precisas de conceder permissão para iniciar o VPN.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage(
      "Ocorreu um erro ao configurar o túnel",
    ),
    "typeDelete": m29,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Digite seu feedback aqui..."),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ucrânia"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Não foi possível conectar ao processador de pagamento! Tente novamente.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("Você não está conectado"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Entre para acessar sua conta e desbloquear todos os recursos",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("Você não está conectado"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("DESPROTEGIDO"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Velocidade instável"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Atualizar"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("Melhor velocidade"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "Conecte-se ao servidor mais rápido disponível para desempenho ideal",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Servidor especial"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Baixa latência"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Conecta você automaticamente ao servidor mais próximo para acesso estável e confiável",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Privacidade máxima"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Obtenha um servidor com as melhores opções de liberdade de expressão e velocidade conforme o país",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("Local mais próximo"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Conecta você ao IP de VPN disponível mais próximo para melhor velocidade e desempenho conforme sua localização atual",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Escolha o melhor servidor para transações cripto seguras, compartilhamento de arquivos, hospedagem de jogos e comunicações",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Acesse seus programas e filmes favoritos de plataformas específicas de cada região",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("Ver todos os recursos"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("Ver menos"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("Protocolo VPN"),
    "year": MessageLookupByLibrary.simpleMessage("ano"),
    "yearly": MessageLookupByLibrary.simpleMessage("anual"),
    "yes": MessageLookupByLibrary.simpleMessage("Sim"),
    "zh": MessageLookupByLibrary.simpleMessage("Chinês"),
  };
}

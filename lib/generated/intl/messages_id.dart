// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a id locale. All the
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
  String get localeName => 'id';

  static String m0(date) => "Akses tersedia hingga ${date}";

  static String m1(store) =>
      "Kamu sudah punya langganan aktif yang dibayar lewat ${store}. Kelola di ${store}.";

  static String m2(amount, period) => "${amount} /${period}";

  static String m3(amount, period) => "${amount}/bulan — Ditagih ${period}";

  static String m4(location) => "Hubungkan ke ${location}";

  static String m5(couponCode) => "${couponCode} disalin ke papan klip!";

  static String m6(email) => "Kami mengirim email ke ${email}";

  static String m7(email) => "Kamu mungkin sudah punya langganan berbayar dengan “${email}”";

  static String m8(errorCode) => "Gagal terhubung. Coba lagi [error: ${errorCode}]";

  static String m9(plan) => "Ambil ${plan}";

  static String m10(plan) => "Ambil paket ${plan}";

  static String m11(count) => "Kumpulan IP: ${count}";

  static String m12(location) =>
      "Tidak ada IP alternatif tersedia di ${location}. Pilih negara atau kota lain untuk mendapat IP berbeda lain kali.";

  static String m13(location) =>
      "Tidak ada IP alternatif tersedia di ${location}. Pilih negara lain untuk mendapat IP berbeda lain kali.";

  static String m14(count) =>
      "${Intl.plural(count, zero: '${count} Kota', other: '${count} Kota')}";

  static String m15(count) => "${Intl.plural(count, zero: '${count} IPs', other: '${count} IPs')}";

  static String m16(count) =>
      "${Intl.plural(count, zero: '${count} Negara Bagian', other: '${count} Negara Bagian')}";

  static String m17(location) => "${location} tidak tersedia";

  static String m18(location) => "Tidak bisa memperbarui ${location}";

  static String m19(location) => "${location} diperbarui";

  static String m20(date) => "Tagihan Berikutnya: ${date}";

  static String m21(count) =>
      "${Intl.plural(count, zero: '', other: 'Jeda selama ${count} bulan')}";

  static String m22(date) => "Dijeda hingga ${date}";

  static String m23(protocol, label) => "${protocol} (${label})";

  static String m24(location) => "Segarkan ${location}";

  static String m25(date) => "Diperpanjang pada ${date}";

  static String m26(count) =>
      "${Intl.plural(count, zero: 'Kirim lagi', other: 'Kirim lagi (${count})')}";

  static String m27(percent) => "Hemat ${percent}%";

  static String m28(percent, planId) => "Hemat ${percent}% dengan paket ${planId}";

  static String m29(plan) => "Tingkatkan ke ${plan}";

  static String m30(plan) => "Tingkatkan ke paket ${plan}";

  static String m31(location) => "Beralih ke ${location}";

  static String m32(word) => "Ketik ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Sedang masuk..."),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Terima penawaran"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Akses tersedia hingga:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "Tidak bisa mengakses situs yang diblokir",
    ),
    "accessUntil": m0,
    "account": MessageLookupByLibrary.simpleMessage("Akun"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Akun dihapus"),
    "activeSubsPaidVia": m1,
    "allLocations": MessageLookupByLibrary.simpleMessage("Semua lokasi"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("Izinkan"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Izinkan notifikasi"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("Izinkan notifikasi"),
    "and": MessageLookupByLibrary.simpleMessage(" dan "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "Versi baru aplikasi sudah ada! Perbarui sekarang untuk fitur dan peningkatan terbaru.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage(
      "Pembaruan Aplikasi Tersedia!",
    ),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("Pembaruan Aplikasi Tersedia"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Tampilan"),
    "ar": MessageLookupByLibrary.simpleMessage("Arab"),
    "austria": MessageLookupByLibrary.simpleMessage("Austria"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage("Tidak bisa masuk. Coba lagi."),
    "back": MessageLookupByLibrary.simpleMessage("Kembali"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Kembali ke Pengaturan"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("Hemat baterai"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlin, Jerman 🇩🇪"),
    "billedInTotal": m2,
    "billedPerMonth": m3,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Pemblokir"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Perbarui sekarang"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Lewati pembatasan"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("Batal"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Terputus"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Waktu henti"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Kesalahan 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Latensi"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Fitur hilang"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Kecepatan"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Yakin ingin membatalkan langgananmu?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Batalkan langganan"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "Langgananmu akan dibatalkan. Kamu tetap bisa memakai Mysterium VPN hingga aksesmu berakhir.",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage(
      "Masukkan detail selengkapnya...",
    ),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage(
      "Ceritakan lebih lanjut (opsional)",
    ),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("Alasan pembatalan"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Terlalu mahal"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "Tidak dapat mengakses situs yang diblokir",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Masalah kegunaan"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Batalkan langgananmu di langganan App Store sebelum menghapus akun.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("Tanggal pembatalan:"),
    "cancelled": MessageLookupByLibrary.simpleMessage("Dibatalkan"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "Kami tidak bisa mengambil info paketmu.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage("Info paket tidak tersedia"),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage("Mengambil info paket..."),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("Cek emailmu"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Hapus pencarian"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Tutup"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("Komunikasi"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("KOMUNIKASI"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Selesai"),
    "confirm": MessageLookupByLibrary.simpleMessage("Konfirmasi"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("Konfirmasi pembatalan"),
    "connect": MessageLookupByLibrary.simpleMessage("Hubungkan"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("Server terbaik"),
    "connectToLocationBtn": m4,
    "connected": MessageLookupByLibrary.simpleMessage("Terhubung"),
    "connectedSince": MessageLookupByLibrary.simpleMessage("Durasi koneksi"),
    "connecting": MessageLookupByLibrary.simpleMessage("Menghubungkan"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Menghubungkan ke pemroses pembayaran...",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Koneksi"),
    "connectionDetails": MessageLookupByLibrary.simpleMessage("Detail koneksi"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Koneksi & Perlindungan"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Koneksi habis waktu. Coba lagi nanti. Jika masalah berlanjut, hubungi tim dukungan",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Kecepatan konsisten"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "Ini hanya berfungsi di perangkat yang memintanya - klik tautan di emailmu untuk lanjut.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Lanjut"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "Kamu akan diarahkan ke situs Mysterium VPN untuk menyelesaikan pembatalan.",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "Lanjutkan pembatalan di web",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("Lanjut batalkan"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("Lanjut ke situs"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Lanjutkan dengan Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("Lanjutkan dengan Email"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Lanjutkan dengan Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Salin tautan dan tempel di browser-mu"),
    "couponCodeCopied": m5,
    "dark": MessageLookupByLibrary.simpleMessage("Gelap"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Mudah dideteksi"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage("Sering diblokir situs"),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Kurang privat"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP PUSAT DATA"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("Kebanyakan VPN"),
    "datacenterIpBadge": MessageLookupByLibrary.simpleMessage("IP datacenter"),
    "de": MessageLookupByLibrary.simpleMessage("Jerman"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Hapus akun"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("Hapus Akun?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Hapus"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah mencapai jumlah maksimum perangkat terhubung. Untuk menambah perangkat baru, hapus salah satu dari akunmu.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("Buka Dasbor"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("Batas Perangkat Tercapai"),
    "disconnect": MessageLookupByLibrary.simpleMessage("Putuskan"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Terputus"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Memutuskan"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Cuma"),
    "dismissNewIpPreview": MessageLookupByLibrary.simpleMessage("Tutup pratinjau IP baru"),
    "dns": MessageLookupByLibrary.simpleMessage("Perlindungan DNS"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("Mencegah kebocoran DNS"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Selesai"),
    "duration": MessageLookupByLibrary.simpleMessage("Durasi"),
    "email": MessageLookupByLibrary.simpleMessage("Alamat email"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("Alamat email tidak valid"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("Alamat email wajib diisi"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notifikasi Email"),
    "emailSentTo": m6,
    "en": MessageLookupByLibrary.simpleMessage("Inggris"),
    "es": MessageLookupByLibrary.simpleMessage("Spanyol"),
    "existingSubscriptionDesc": m7,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "Kamu bisa keluar dan coba dengan emailmu atau abaikan peringatan ini",
    ),
    "failedToConnectError": m8,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "Gagal mengirim masukan. Coba lagi.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Ada yang salah dengan langgananmu. Coba lagi!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "Kami tidak dapat memverifikasi pembelian langganan terakhirmu. Ketuk tombol di bawah untuk mencoba lagi.",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("Cepat"),
    "favoriteIpAddAction": MessageLookupByLibrary.simpleMessage("Tambahkan ke IP favorit"),
    "favoriteIpAddedToast": MessageLookupByLibrary.simpleMessage("IP ditambahkan ke favorit"),
    "favoriteIpLimitReached": MessageLookupByLibrary.simpleMessage(
      "Batas IP favorit tercapai. Hapus satu IP untuk menyimpan yang baru.",
    ),
    "favoriteIpRemoveAction": MessageLookupByLibrary.simpleMessage("Hapus dari IP favorit"),
    "favoriteIpRemovedToast": MessageLookupByLibrary.simpleMessage("IP dihapus dari favorit"),
    "favoriteIpsDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Ketersediaan IP tersimpan bisa berubah seiring waktu. IP favoritmu menjadi tidak tersedia, jadi kami menghubungkanmu ke lokasi tersedia terdekat.",
    ),
    "favoriteIpsEmptyBody": MessageLookupByLibrary.simpleMessage(
      "Hubungkan lalu ketuk ikon hati di kartu koneksi untuk menyimpan IP agar bisa diakses cepat.",
    ),
    "favoriteIpsEmptyTitle": MessageLookupByLibrary.simpleMessage("Belum ada IP favorit"),
    "favoriteIpsLabel": MessageLookupByLibrary.simpleMessage("IP favorit"),
    "favoriteIpsLockedBody": MessageLookupByLibrary.simpleMessage(
      "Tingkatkan ke Plus atau Pro untuk menyimpan IP yang paling cocok untukmu dan mengaksesnya kapan saja.",
    ),
    "favoriteIpsLockedTitle": MessageLookupByLibrary.simpleMessage("Simpan IP favorit"),
    "favoriteIpsNotAvailableOnPlan": MessageLookupByLibrary.simpleMessage(
      "IP tersimpan tidak tersedia di paketmu saat ini.",
    ),
    "favoriteIpsTab": MessageLookupByLibrary.simpleMessage("Favorit"),
    "favoriteIpsUnavailableHeading": MessageLookupByLibrary.simpleMessage("IP tidak tersedia"),
    "favoriteIpsUpgradePlan": MessageLookupByLibrary.simpleMessage("Tingkatkan paket"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "Versi aplikasimu sudah usang. Perbarui aplikasi untuk terus memakainya.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Data formulir tidak valid. Periksa kolomnya dan coba lagi.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Prancis"),
    "france": MessageLookupByLibrary.simpleMessage("Prancis"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("Sering terputus"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Harga penuh:"),
    "germany": MessageLookupByLibrary.simpleMessage("Jerman"),
    "getAPlanBtn": MessageLookupByLibrary.simpleMessage("Dapatkan paket"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage(
      "Dapatkan alamat IP baru saat menyegarkan",
    ),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Amankan koneksimu dan nikmati penjelajahan privat seketika",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("Mengambil alamat IP..."),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Kembali"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Ke halaman masuk"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Bantuan & Dukungan"),
    "hi": MessageLookupByLibrary.simpleMessage("Hindi"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Tersembunyi"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("Latensi tinggi"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Beranda"),
    "id": MessageLookupByLibrary.simpleMessage("Indonesia"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Lokasi salah"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage("Magic link salah. Coba lagi."),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("Alamat IP"),
    "ipDetails": MessageLookupByLibrary.simpleMessage("Detail IP"),
    "ipPool": MessageLookupByLibrary.simpleMessage("Pool IP"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipType": MessageLookupByLibrary.simpleMessage("Jenis IP"),
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("IP datacenter"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "IP datacenter dioptimalkan untuk kecepatan dan performa.",
    ),
    "ipTypeDataCenterTab": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("IP residensial"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Disediakan oleh rumah tangga asli. Nyaris tak terdeteksi tapi kurang stabil.",
    ),
    "ipTypeResidentialTab": MessageLookupByLibrary.simpleMessage("Residensial"),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "IP residensial disediakan oleh perangkat rumah tangga asli, jadi ketersediaannya bisa berubah seiring waktu.\n\nJika sebuah node offline, aplikasi akan menyambungkanmu ke IP residensial terdekat yang tersedia.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "Kenapa IP-ku bisa berubah?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("Italia"),
    "italy": MessageLookupByLibrary.simpleMessage("Italia"),
    "ja": MessageLookupByLibrary.simpleMessage("Jepang"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Pertahankan langganan"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "Memblokir lalu lintas internet jika koneksi VPN terputus",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Bahasa"),
    "light": MessageLookupByLibrary.simpleMessage("Terang"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Tautan disalin ke papan klip!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "Tautan kedaluwarsa dalam 30 menit dan hanya bisa dipakai sekali.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Lokasi"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Lokasi"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("Hubungkan ke IP terdekat"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "Hubungkan ke IP terdekat - atau pilih manual",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Sesimu sudah kedaluwarsa. Masuk lagi.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Masuk atau daftar"),
    "logout": MessageLookupByLibrary.simpleMessage("Keluar"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage("Kamu akan keluar. Yakin?"),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Keluar"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN aktif. Kamu akan terputus dari server VPN jika melanjutkan keluar.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Latensi rendah"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madrid, Spanyol 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Malware"),
    "manageFavoriteIpsBtn": MessageLookupByLibrary.simpleMessage("Kelola"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Kelola di web"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Mau menerima pembaruan email, tips privasi, dan penawaran khusus dari Mysterium Network?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage("Tetap terkini lewat email"),
    "month": MessageLookupByLibrary.simpleMessage("bulan"),
    "monthly": MessageLookupByLibrary.simpleMessage("bulanan"),
    "myIp": MessageLookupByLibrary.simpleMessage("IP saya"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Lokasi"),
    "navMap": MessageLookupByLibrary.simpleMessage("Peta"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Produk"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Tanggal penagihan berikutnya:"),
    "no": MessageLookupByLibrary.simpleMessage("Tidak"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("Kamu tidak punya langganan aktif"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("Tidak ada aplikasi email di perangkatmu."),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("Tidak ada lokasi ditemukan"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("Tidak ada server tersedia"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "Ada masalah konektivitas dan tidak ada server tersedia. Coba lagi nanti.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Ambil paket"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Tidak ada paket aktif tersedia"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("Tidak ada"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("Tidak tersedia"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Nanti saja"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage("Belum siap membatalkan?"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW & Malware"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "IP dan lokasimu terlihat oleh situs, pelacak, dan jaringan Wi-Fi publik.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("Koneksimu terekspos"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN menyamarkan IP, ISP, dan lokasimu agar kamu bisa menjelajah dengan privasi nyata.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Sembunyikan identitas aslimu dalam satu ketukan",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "Dengan IP residensial, koneksimu tampak alami - bukan seperti lalu lintas VPN biasa.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("Tidak semua VPN bekerja sama"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("Buka aplikasi email"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Buka pengaturan sistem"),
    "optional": MessageLookupByLibrary.simpleMessage("opsional"),
    "or": MessageLookupByLibrary.simpleMessage("ATAU"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "Kami akan menghubungkanmu ke server terbaik - atau kamu bisa memilih negara secara manual.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Lainnya..."),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Pilih salah satu durasi jeda.",
    ),
    "pauseForMonths": m21,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Jeda langganan"),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Kamu bisa menjeda paketmu sekali per siklus penagihan.",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("Dijeda"),
    "pausedUntil": m22,
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah punya transaksi pembayaran yang berjalan. Selesaikan dulu sebelum memulai yang baru.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("bln"),
    "pl": MessageLookupByLibrary.simpleMessage("Polandia"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah siap! Paket ini sudah aktif.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("Paket 2 Tahun"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 tahun"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 tahun"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("Paket 6 Bulan"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Paket Bulanan"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic bulanan"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus bulanan"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro bulanan"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Paket Tahunan"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic tahunan"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus tahunan"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro tahunan"),
    "poland": MessageLookupByLibrary.simpleMessage("Polandia"),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferensi"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("Lihat semua paket"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Kebijakan Privasi"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "Kami sedang memproses pembayaranmu. Sebentar lagi siap...",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah punya paket aktif. Tingkatkan di web - perubahan sinkron otomatis",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("Semua paket:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "Esensial untuk privasi sehari-hari",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 bulan"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 Tahun"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 Tahun"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("Jelajahi paket dan fitur"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("Kelola dan tingkatkan di web"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah pakai paket tertinggi yang tersedia.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Tidak ada produk tersedia saat ini. Coba lagi nanti.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage(
      "Lebih banyak perangkat, lebih banyak lokasi",
    ),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Perlindungan maksimal untuk pengguna berat",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "Langganan dikelola di web. Paketmu akan sinkron ke aplikasi secara otomatis.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("Berlangganan di web"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("Produk VPN"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("TERLINDUNGI"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protokol"),
    "protocolLabel": m23,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Mengganti protokol VPN akan memutuskan koneksimu. Kamu perlu menyambung ulang setelahnya.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("Mengganti protokol VPN"),
    "pt": MessageLookupByLibrary.simpleMessage("Portugis"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Portugis Brasil"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Dapatkan notifikasi soal fitur baru, tips bermanfaat, dan penawaran eksklusif - cuma pembaruan yang berguna.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Tetap terkini dengan notifikasi push",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Notifikasi Push"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Pembaruan produk, tips, dan penawaran khusus",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("Bagaimana koneksimu?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("Apa yang kurang kamu suka?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("Apa yang kamu suka?"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "Kamu bisa mengaktifkan ulang langgananmu kapan saja sebelum aksesmu berakhir.",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Lokasi terkini"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("Tukarkan kode diskon"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Akunmu berhasil dihapus. Kamu akan dialihkan ke layar masuk.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Segarkan"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("Segarkan IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("Segarkan alamat IP"),
    "refreshLocationsTooltip": m24,
    "renewsOn": m25,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("Reset saat ada yang tidak berfungsi"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "Jika kamu lanjut mereset aplikasi, kamu akan terputus dari Mysterium VPN.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage("Koneksi VPN sedang aktif"),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage("Gagal mereset aplikasi. Coba lagi."),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("Aplikasi berhasil direset."),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("Reset aplikasi"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Reset"),
    "residential": MessageLookupByLibrary.simpleMessage("Residensial"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Tampak seperti pengguna asli",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Lebih sulit dideteksi",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage(
      "Lebih jarang diblokir",
    ),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("IP RESIDENSIAL"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "IP residensial berasal dari perangkat rumah tangga asli, membuat lalu lintasmu tampak seperti penggunaan internet biasa.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage(
      "Perangkat rumah tangga asli",
    ),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Karena IP ini berasal dari perangkat nyata, beberapa node bisa offline dari waktu ke waktu.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "Ketersediaan bisa berubah",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "Jika IP-mu saat ini tidak tersedia, aplikasi akan menyambungkanmu ke IP residensial terdekat yang tersedia.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage(
      "Penyambungan ulang otomatis",
    ),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("Mengerti"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "IP residensial berbeda dari IP datacenter. Berikut yang bisa kamu harapkan.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage("Cara kerja IP residensial"),
    "residentialIpBadge": MessageLookupByLibrary.simpleMessage("IP residensial"),
    "resumeBtn": MessageLookupByLibrary.simpleMessage("Lanjutkan"),
    "resumeSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Langgananmu akan langsung dilanjutkan.",
    ),
    "resumeSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Lanjutkan langganan?"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Beri ulasan"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "Bagus sekali! Mau memberi kami ulasan?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "Apakah kamu akan merekomendasikan aplikasi ini ke orang lain?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Cari lokasi"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("Lihat paket"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage("Pilih Aplikasi Email untuk Lanjut"),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("per semester"),
    "sendAgain": m26,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "Kami sedang mengalami gangguan jaringan sementara. Coba lagi nanti..",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Kelola"),
    "settings": MessageLookupByLibrary.simpleMessage("Pengaturan"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Untuk memakai Mysterium VPN, kami butuh izinmu memasang profil VPN.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Anonimitasmu aman. Kami tidak melihat, mengumpulkan, atau menyimpan aktivitas penjelajahanmu.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage("Kami butuh izinmu"),
    "signIn": MessageLookupByLibrary.simpleMessage("Masuk ke Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Masuk dibatalkan"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Masuk"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN tidak mencatat aktivitas online-mu, dan tidak ada catatan yang terkait denganmu, perangkatmu, alamat IP-mu, atau emailmu. Dengan masuk, kamu setuju dengan",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 bulan"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Lewati"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage("Ada yang salah. Coba lagi!"),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Koneksi stabil"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Tetap di sini"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("Tetap di aplikasi"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Kirim"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("Berlangganan di web"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "Kabar baik! Langgananmu sekarang aktif.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Kembali ke paket"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "Bandingkan semua fitur",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Paket saat ini"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Ambil paket"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Bulanan"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 Tahun"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("Semua paket"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Tingkatkan paketmu"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("Langganan dibatalkan"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "Jelajahi fitur canggih seperti protokol VPN dan pemblokiran malware.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Tingkatkan perlindunganmu",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("Lewati dulu"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "Kami akan menghubungkanmu ke server terbaik.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Terhubung untuk tetap privat",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Beli, tingkatkan, atau lihat paket yang tersedia berdasarkan akses akunmu.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage("Kelola paketmu"),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Telusuri peta atau jelajahi lokasi dari bilah sisi.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Jelajahi lokasi sesukamu",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Telusuri peta untuk memilih negara dan terhubung seketika.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "Terhubung dari peta",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Pelajari cara memakai aplikasi yang diperbarui dan temukan letak fitur utama sekarang.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage("Ikuti tur singkat"),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Temukan negara, kota, dan server dengan cepat lewat pencarian.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Cari dan terhubung lebih cepat",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Pilih lokasi untuk mulai menjelajah lebih privat.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Pengaturan selesai",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("Mulai tur"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Jelajahi negara dan kota di satu tempat.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Jelajahi negara, kota, koneksi terkini, dan server khusus di satu tempat.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "Telusuri lokasi VPN",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("PALING HEMAT"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("Pilihan tingkat kota"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Memberi kontrol lokasi yang lebih presisi dibanding kebanyakan VPN, yang biasanya hanya membiarkanmu memilih seluruh negara atau wilayah.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Perangkat diamankan sekaligus",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("Double VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Lapisan keamanan ekstra. Mengarahkan lalu lintas internetmu lewat dua server VPN berbeda, mengenkripsi datamu dua kali dan menyembunyikan alamat IP-mu di balik server kedua",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("Pemblokir malware"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Melindungi perangkatmu dengan menghentikan ancaman sebelum mencapainya, berjalan diam di latar belakang tanpa mengganggumu.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "Garansi uang kembali 7 hari",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage(
      "Amankan 6 perangkat sekaligus",
    ),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage(
      "Amankan 10 perangkat sekaligus",
    ),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 negara didukung"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage("100+ negara didukung"),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 server"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 server"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("Protokol VPN"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("7.500+ IP residensial"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("Protokol VPN"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("Pilihan tingkat kota"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("IP residensial"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Tampil sebagai pengguna rumahan biasa, memungkinkanmu mengakses layanan streaming dan menghindari deteksi VPN.",
    ),
    "subscriptionPlanSavePercent": m27,
    "subscriptionPlanSaveWith": m28,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Server"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage("Negara didukung"),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("Protokol VPN"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - protokol cepat, terbaik untuk gaming dan streaming\nOpenVPN - protokol yang sangat mudah dikonfigurasi dan bekerja saat protokol lain gagal (tidak tersedia di Android)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "Kamu belum menyelesaikan perubahan pada langgananmu.",
    ),
    "subscriptionResumed": MessageLookupByLibrary.simpleMessage("Langgananmu aktif lagi."),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Tingkatkan"),
    "subscriptionUpgradeCTA": m29,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "untuk mengakses 7.500+ IP residensial",
    ),
    "subscriptionUpgradeModalTitle": m30,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("Lihat semua paket"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("Ulangi Verifikasi"),
    "subscripton": MessageLookupByLibrary.simpleMessage("Langganan"),
    "switchToLocationBtn": m31,
    "system": MessageLookupByLibrary.simpleMessage("Sistem"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("Rebut kembali internet."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Syarat dan Ketentuan"),
    "title": MessageLookupByLibrary.simpleMessage("Halo"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Terlalu banyak permintaan. Coba lagi nanti.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage("Token sudah dipakai. Coba lagi.\n"),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Putuskan"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("Sambung ulang"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah mencapai batas maksimum 6 perangkat terhubung di akunmu. Untuk terus memakai VPN, klik untuk sambung ulang.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "Kamu sudah mencapai batas maksimum 6 perangkat terhubung di akunmu. Untuk terus memakai VPN, klik putuskan dan coba lagi.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("Kamu Telah Terputus"),
    "topLocations": MessageLookupByLibrary.simpleMessage("Lokasi teratas"),
    "tr": MessageLookupByLibrary.simpleMessage("Turki"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Coba lagi"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage("Coba cari lokasi lain"),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Kamu perlu memberikan izin untuk memulai tunnel VPN.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage(
      "Terjadi kesalahan saat menyiapkan tunnel",
    ),
    "typeDelete": m32,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Ketik masukanmu di sini..."),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ukraina"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Tidak bisa terhubung ke pemroses pembayaran! Coba lagi.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("Kamu belum masuk"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Masuk untuk mengakses akunmu dan membuka semua fitur",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("Kamu belum masuk"),
    "undo": MessageLookupByLibrary.simpleMessage("Urungkan"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("TAK TERLINDUNGI"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Kecepatan tidak stabil"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Perbarui"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("Kecepatan terbaik"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "Terhubung ke server tercepat yang tersedia untuk performa optimal",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Server khusus"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Latensi rendah"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Otomatis menghubungkanmu ke server terdekat untuk akses stabil dan andal",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Privasi maksimal"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Dapatkan server dengan opsi kebebasan berbicara dan kecepatan terbaik berdasarkan negara",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("Lokasi terdekat"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Menghubungkanmu ke IP VPN terdekat yang tersedia untuk kecepatan dan performa terbaik berdasarkan lokasimu saat ini",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Pilih server terbaik untuk transaksi kripto aman, berbagi file, hosting game, dan komunikasi",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Akses acara dan film favoritmu dari platform khusus wilayah tertentu",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("Lihat semua fitur"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("Tampilkan lebih sedikit"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnDetails": MessageLookupByLibrary.simpleMessage("Detail VPN"),
    "vpnIp": MessageLookupByLibrary.simpleMessage("IP VPN"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("Protokol VPN"),
    "year": MessageLookupByLibrary.simpleMessage("tahun"),
    "yearly": MessageLookupByLibrary.simpleMessage("tahunan"),
    "yes": MessageLookupByLibrary.simpleMessage("Ya"),
    "zh": MessageLookupByLibrary.simpleMessage("Mandarin"),
  };
}

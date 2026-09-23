import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn/common/utils/url_launcher.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

enum _FailureType {
  // Failure to load the terms and conditions
  loading(
    title: "We couldn't save your acceptance",
    content:
        'Something went wrong while accepting the updated Terms & Conditions. Please try again to continue using Mysterium VPN.',
  ),
  // Failure to save the terms and conditions
  saving(
    title: "We couldn't load the Terms & Conditions",
    content:
        'The updated Terms & Conditions need to be available for you to review before you can accept them. Please try again.',
  );

  const _FailureType({required this.title, required this.content});

  final String title;
  final String content;
}

class TermsConditionsChecker extends HookWidget {
  const TermsConditionsChecker({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final canContinue = useState(true);

    return canContinue.value ? child : const _TermsConditionsPage();
  }
}

class _TermsConditionsPage extends StatelessWidget {
  const _TermsConditionsPage();

  EdgeInsets get mobilePadding => const EdgeInsets.fromLTRB(16, 0, 16, 24);
  EdgeInsets get desktopPadding => const EdgeInsets.fromLTRB(180, 40, 180, 24);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredScaffold(
      backgroundColor: theme.palette.bgSidePanel,
      body: SafeArea(
        child: Padding(
          padding: isDesktop() ? desktopPadding : mobilePadding,
          child: const Column(
            children: [
              _TermsConditionsHeader(),
              Expanded(child: _TermsConditionsContent()),
              // _TermsConditionsError(failure: _FailureType.loading),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsConditionsContent extends HookWidget {
  const _TermsConditionsContent();

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(height: theme.spacing.xl2),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            scrollbarOrientation: ScrollbarOrientation.right,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Scrollbar(
                child: Container(
                  padding: EdgeInsets.all(theme.spacing.xl2),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.palette.borderPrimary),
                    borderRadius: BorderRadius.circular(theme.radius.xxxs.x),
                  ),
                  child: HtmlWidget(
                    termsConditionsHtml,
                    textStyle: theme.textStyles.textSm.regular.copyWith(
                      color: theme.palette.textTertiary,
                    ),
                    onTapUrl: (url) =>
                        openUrlLink(Uri.parse(url), source: RedirectSource.termsOfService),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: theme.spacing.xl2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 343, minHeight: 44),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ButtonPrimary(onPressed: () => print('hello'), child: const Text('Accept')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TermsConditionsError extends StatelessWidget {
  const _TermsConditionsError({required this.failure});

  final _FailureType failure;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(height: isDesktop() ? theme.spacing.xl7 : theme.spacing.xl6),
        AlertModal(
          icon: UntitledUI.alert_circle,
          screenType: ScreenType.mobile,
          type: AlertModalType.error,
          title: failure.title,
          supportingText: failure.content,
          backgroundColor: theme.palette.bgPrimary,
          borderColor: theme.palette.borderPrimary,
          primaryButton: Row(
            children: [
              ButtonTertiary(
                onPressed: () => print('pressed'),
                decoration: const ButtonDecoration(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TermsConditionsHeader extends StatelessWidget {
  const _TermsConditionsHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          minRadius: 24,
          backgroundColor: theme.palette.bgSecondarySelected,
          child: Icon(UntitledUI.check_circle, color: theme.palette.iconBrandSecondary, size: 32),
        ),
        SizedBox(height: theme.spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Our Terms & Conditions have changed',
                textAlign: TextAlign.center,
                style: theme.textStyles.textLg.bold.copyWith(fontSize: 24),
              ),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "We've updated our Terms & Conditions. Please review and accept the updated Terms to continue using Mysterium VPN.",
                textAlign: TextAlign.center,
                style: theme.textStyles.textMd.regular.copyWith(color: theme.palette.textTertiary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

const String termsConditionsHtml = '''

<!doctype html><html lang="en"><head><meta charset="UTF-8"></head><body><h1 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;">General Terms of Service</h1><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">These Terms of Service  (“Terms”) are a binding legal agreement between you and UAB MN Intelligence   (“we”, “us” or “our”) that governs your use of the VPN services (“Services”) and the software (“Software”) provided by us.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">1) Acceptance of terms</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">By downloading, installing, or using the Software and/or accessing or using the Services, you are fully accepting the terms, conditions, and disclaimers contained in this document and all policies and guidelines that are incorporated by reference. You acknowledge that you have read and understood the Terms and agree to be bound by its terms. If you do not agree to the Terms, do not use the Services or the Software.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Our Services may also be subject to the supplementary terms (the “Supplementary Terms”) governing that particular service. If there is a conflict between the Terms and Supplementary Terms, then the Supplementary Terms shall prevail in relation to that particular service.By agreeing to these Terms, you are also agreeing to the Privacy Policy (the “Privacy Policy”). You shall not use the Services in contradiction with these Terms or any applicable law or regulation of the country or territory you originate from or reside in or any applicable jurisdiction (the “Applicable Law”).You shall not use the Services for any purpose that is unlawful or prohibited by these Terms and the Applicable Law.We acknowledge that the laws of certain jurisdictions provide legal rights to consumers that may not be overridden by contract or waived by those consumers. If you are such a consumer, nothing in these Terms limits any of those consumer rights.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">2) Changed terms</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">We shall have the right at any time to change or modify the Terms or any part thereof. We reserve the right to amend the fees or institute new fees at any time upon reasonable advance notice posted on this website, application, or sent via email. Unless it is stated by us otherwise, such changes, modifications, additions, or deletions shall be effective immediately upon notice published on this website. Any use of the Services after such notice shall be deemed to constitute acceptance of such changes, modifications, or additions.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">3) Scope</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Subject to (a) your compliance with these Terms and any Applicable Laws and (b) payment of all fees in full, we will permit you to access and use the Services during the Subscription Term (as defined below). The Services will be made accessible to you via the Software. You must download and install the Software to access and use the Services.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">4) Subscription</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">The Services are provided on a subscription basis for the term and in accordance with the respective subscription plan purchased by you (“Subscription Term” and “Subscription Plan”, respectively, and collectively the “Subscription”). We offer several Subscription Plans (for example, Basic, Plus, and Pro) for our Services, which may differ in available features, number of allowed devices, or other functionality. Details of each Subscription Plan are listed on our website.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">During the Subscription Term, you can upgrade your Subscription, and we will adjust the fees accordingly on a pro-rata basis.Upon expiration of the Subscription Term, you will be enrolled in an automatic renewing cycle for the same term and for the same Subscription Plan, unless you cancel your Subscription before the end of the Subscription Term. The same will apply for each renewed Subscription Term.We may change the offered Subscription Plans, including the fees. Any changes will be communicated to you as per section 2 herein. We reserve the right to modify, discontinue, or replace Subscription Plans, provided that such changes do not affect your existing Subscription Term or increase your current fees. If your current Subscription features and price remain the same, you may be automatically transitioned to an equivalent plan. Your use of the Services after such changes shall be deemed to constitute acceptance of such changes.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">We offer a refund period (“Refund Period”). During this Refund Period, you may request a full refund in accordance with the terms set out in section 8, provided you comply with our refund policy. </p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">5) Limited license</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Subject to (a) your compliance with these Terms and any Applicable Laws and (b) payment of all fees and charges in full, we grant you a limited, non-exclusive, non-transferable, non-sublicensable,  revocable license to install and use a copy of the Software during the Subscription Term.You shall not (a) defeat, disable, or circumvent any protection mechanism related to the Software; (b) use the Software or any parts of it to develop a product directly competing with the Software; (c) distribute the Software or derivative works based on the Software and (or) (d) sublicense, sell, resell, transfer, assign, distribute, or otherwise commercially exploit or make available to any third party the Services, Subscription, and/or account in any way.You shall not remove any product identification, copyright notices, or proprietary restrictions from the Software. Nothing contained herein shall be construed, expressly or implicitly, as transferring any right, license, or title to you other than those explicitly granted under the Terms. Unauthorized copying of the Software or failure to comply with the restrictions herein will result in automatic termination of these Terms and will constitute immediate, irreparable harm to us for which monetary damages would be an inadequate remedy, in which case injunctive relief will be an appropriate remedy for such breach.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">6) Your ID and security</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">An ID and a private key (jointly, the “ID Data”) will be automatically created for you when you use the Services for the first time. You are entirely responsible for maintaining the confidentiality of your ID Data. Furthermore, you are entirely responsible for any activities that occur under your ID Data. You agree to notify us immediately of any unauthorized use of your account or any other breach of security. We will not be liable for any loss that you may incur as a result of someone else using your ID Data, either with or without your knowledge. However, you could be held liable for losses incurred by us or another party due to someone else using your account. You may not use anyone else's ID Data at any time without the permission of the account holder.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Sharing login credentials or access with any third party (including posting credentials publicly, selling, renting, or otherwise transferring access) is strictly prohibited.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">7) Payments</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Any fees charged by us are exclusive of taxes. Therefore, we may calculate and add any applicable taxes or fees, including, but not limited to VAT and other taxes and fees under the laws applicable to you. Such taxes and fees will be calculated according to the payment information provided by you to us at the time of purchasing the Services. For this purpose, you must provide us with accurate information, including information about your country of residence, and agree to indemnify and hold harmless us, our affiliates, and their respective directors, officers, employees, and agents from and against all claims and expenses, including attorneys' fees, arising in connection with the inaccurate, false, or incomplete information.By using any payment method, including cryptocurrency payments, debit or credit card, to purchase the Services, you confirm that you are the rightful owner of such an instrument or that you have permission from the account holder or cardholder to use it. Moreover, it is your responsibility to ensure that your debit or credit card account has sufficient funds to pay for the charges. We shall not be responsible for any additional charges that may be imposed on you by your bank or card issuer.We reserve the right to block or suspend the Services if we have reasonable cause to suspect fraudulent use of a payment account, credit, or debit card.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">8) Cancellation, refund, and right of withdrawal </strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">You may cancel the Services at any time by emailing <a href='mailto:help@mysteriumvpn.com'>help@mysteriumvpn.com</a>. Upon cancellation, access will continue until the end of your current Subscription Term, unless otherwise stated.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">You are entitled to a full refund if you cancel within 7 days of your initial purchase. If you are a consumer residing in the European Union, you have a statutory right to withdraw from your purchase within fourteen (14) days, in accordance with applicable consumer protection laws.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Refunds requested after this period may be granted at our sole discretion, and only if:</p><ul style=list-style: circle><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">The Services were unavailable or unusable due to issues on our side; and</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">You made reasonable efforts to contact support during the disruption.</li></ul><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Refunds are processed in USD to the original payment method and may differ from the amount paid due to exchange rate or cryptocurrency fluctuations. They are typically issued within seven business days.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Each user is eligible for one refund only. If you repurchase after receiving a refund, you waive future refund eligibility. No refund will be granted in case of violation of these Terms. Once a refund is issued, your access to the Services is terminated.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Refunds for purchases made through third-party app stores, marketplaces, retailers, or resellers (including, without limitation, the Apple App Store and Google Play) are governed exclusively by the terms of service and refund policies of those providers.</p><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;"> We reserve the right to deny refunds where we detect abuse of the Services. Abuse includes but is not limited to:</p><ul style=list-style: circle><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Automated high-volume traffic or scripted usage;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Repeated IP renewals for scraping, crawling, or bypassing restrictions;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Excessive short-term use followed by refund requests;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Use of more simultaneous connections than permitted;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Fraudulent, illegal, or exploitative use of the Service.</li></ul><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">We assess abuse using traffic data, usage patterns, and access behavior. Our determination is final. In such cases, no refund will be provided, regardless of the time of request. Abuse may also result in suspension or permanent termination of service.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">9) Equipment</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">You shall be responsible for obtaining and maintaining all hardware, software, and other equipment needed for access to and use of the Services. Should you need any licenses, equipment, or software to access and/or use the resources or services that are made conditional upon prior authorization, you shall be solely responsible for obtaining and maintaining such licenses, equipment, and software. </p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">10) Restricted conduct</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">We do not encourage, support, or contribute to illegal activities. You shall not (and shall not permit, assist, or encourage any other person to), directly or indirectly:</p><ul style=list-style: circle><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Use the Services for any purpose that is unlawful or prohibited by these Terms or the Applicable Law;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Request, receive, post, upload, download, display, distribute, transmit or make available using the Services (“communicate”) any information and material which violates or infringes in any way upon the rights of others, which is unlawful, threatening, abusive, defamatory, invasive of privacy or publicity rights, which encourages conduct that would constitute a criminal offense, give rise to civil liability or otherwise violate the Applicable Law;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Communicate in any way files that contain viruses, worms, trojans, corrupted files, or any other similar software or programs that may damage the operation of another’s computer;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Attempt to gain unauthorized access to any aspect of the Services or to information for which you have not been granted access;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Interfere with or attempt to interfere with the proper working of the Service, any transactions being offered in connection with the Services, or any other activities conducted by us, disrupt our website or any networks connected to the Service, or bypass any measures we may use to prevent or restrict access to the Service;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Collect or harvest personal information about other users of the Service;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Incorporate the Services or any portion thereof into any other program or product;</li></ul><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Use the Services for:</p><ul style=list-style: circle><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Uploading, transmitting, streaming, accessing, receiving, or distributing any copyrighted, trademark, or patented content which you do not own or lack written consent or a license from the owner;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Accessing or using any resources or services (e.g., web pages, television or radio broadcasts, cable or satellite services, streaming media services, VOD services, etc.) that are made conditional upon prior authorization, which you do not have;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Circumventing any access control, technical protection, or security measures;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Extortion, blackmail, kidnapping, rape, murder, sale/purchase of stolen credit cards, sale/purchase of stolen sale/purchase, sale/purchase of illegal sale/purchase, performance of identity theft;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Use of stolen credit cards, credit card fraud, wire fraud; sale of stolen credit cards, sale of stolen goods, offer or sale of prohibited, military and dual use goods, offer or sale of controlled substances;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Hacking, pharming, phishing, or spamming in any form or scale;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Exploitation of or contribution to child exploitation, photographically, digitally, or in any other way;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Assaulting in any way or form any other network or computer;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Taking any action resulting in an unreasonable load on our infrastructure;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Commercial purposes;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">More than six (6) simultaneous connections;</li><li style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">Connecting to the Services any devices, software, and/or hardware that do or may do any of the above.</li></ul><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">11) Privacy policy</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">For information on how we process your personal data, please see our <a href='https://www.mysteriumvpn.com/privacy-policy-vpn'><strong style="font-weight: 700"><u style="text-decoration-line: underline">Privacy Policy</u></strong></a>.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">12) Disclaimer of warranty; limitation of liability</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">YOU EXPRESSLY AGREE THAT USE OF THE SERVICES IS AT YOUR SOLE RISK. NEITHER WE, OUR AFFILIATES NOR ANY OF THEIR RESPECTIVE EMPLOYEES, AGENTS, THIRD PARTY CONTENT PROVIDERS OR LICENSORS WARRANT THAT THE SERVICES AND/OR THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR FREE; NOR DO THEY MAKE ANY WARRANTY AS TO THE RESULTS THAT MAY BE OBTAINED FROM USE OF THE SERVICES AND/OR THE SOFTWARE, OR AS TO THE ACCURACY, RELIABILITY OR CONTENT OF ANY INFORMATION, SERVICE, OR MERCHANDISE PROVIDED THROUGH THE SERVICES.THE SERVICES AND/OR THE SOFTWARE ARE PROVIDED ON AN "AS IS" BASIS WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, WARRANTIES OF TITLE, NON-INFRINGEMENT OR IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, OTHER THAN THOSE WARRANTIES WHICH ARE IMPLIED BY AND INCAPABLE OF EXCLUSION, RESTRICTION OR MODIFICATION UNDER THE LAWS APPLICABLE TO THE TERMS.THIS DISCLAIMER OF LIABILITY APPLIES TO ANY DAMAGES OR INJURY CAUSED BY ANY FAILURE OF PERFORMANCE, ERROR, OMISSION, INTERRUPTION, DELETION, DEFECT, DELAY IN OPERATION OR TRANSMISSION, COMPUTER VIRUS, COMMUNICATION LINE FAILURE, THEFT OR DESTRUCTION OR UNAUTHORIZED ACCESS TO, ALTERATION OF, OR USE OF RECORD, WHETHER FOR BREACH OF CONTRACT, TORTIOUS BEHAVIOR, NEGLIGENCE, OR UNDER ANY OTHER CAUSE OF ACTION. YOU SPECIFICALLY ACKNOWLEDGE THAT WE ARE NOT LIABLE FOR THE DEFAMATORY, OFFENSIVE, OR ILLEGAL CONDUCT OF OTHER USERS OR THIRD-PARTIES AND THAT THE RISK OF INJURY FROM THE FOREGOING RESTS ENTIRELY WITH YOU.IN NO EVENT WILL WE, OR ANY PERSON OR ENTITY INVOLVED IN CREATING, PRODUCING, OR DISTRIBUTING THE SERVICES AND/OR THE SOFTWARE, BE LIABLE FOR ANY DAMAGES, INCLUDING, WITHOUT LIMITATION, DIRECT, INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING OUT OF THE USE OF OR INABILITY TO USE THE SERVICE AND/OR THE SOFTWARE.IN ADDITION TO THE TERMS SET FORTH ABOVE NEITHER, WE, NOR OUR AFFILIATES OR CONTENT PARTNERS SHALL BE LIABLE REGARDLESS OF THE CAUSE OR DURATION, FOR ANY ERRORS, INACCURACIES, OMISSIONS, OR OTHER DEFECTS IN, OR UNTIMELINESS OR UNAUTHENTICITY OF, THE INFORMATION CONTAINED, OR FOR ANY DELAY OR INTERRUPTION IN THE TRANSMISSION THEREOF TO YOU, OR FOR ANY CLAIMS OR LOSSES ARISING THEREFROM OR OCCASIONED THEREBY. NONE OF THE FOREGOING PARTIES SHALL BE LIABLE FOR ANY THIRD-PARTY CLAIMS OR LOSSES OF ANY NATURE, INCLUDING, BUT NOT LIMITED TO, LOST PROFITS, PUNITIVE OR CONSEQUENTIAL DAMAGES.FORCE MAJEURE. NEITHER PARTY WILL BE RESPONSIBLE FOR ANY FAILURE OR DELAY IN PERFORMANCE DUE TO CIRCUMSTANCES BEYOND ITS REASONABLE CONTROL, INCLUDING, WITHOUT LIMITATION, ACTS OF GOD, WAR, RIOT, EMBARGOES, ACTS OF CIVIL OR MILITARY AUTHORITIES, FIRE, FLOODS, ACCIDENTS, SERVICE OUTAGES RESULTING FROM EQUIPMENT AND/OR SOFTWARE FAILURE AND/OR TELECOMMUNICATIONS FAILURES, POWER FAILURES, NETWORK FAILURES, FAILURES OF THIRD PARTY SERVICE PROVIDERS (INCLUDING PROVIDERS OF INTERNET SERVICES AND TELECOMMUNICATIONS). THE PARTY AFFECTED BY ANY SUCH EVENT SHALL NOTIFY THE OTHER PARTY WITHIN A MAXIMUM OF FIFTEEN (15) DAYS FROM ITS OCCURRENCE. THE PERFORMANCE OF THESE TERMS SHALL THEN BE SUSPENDED FOR AS LONG AS ANY SUCH EVENT SHALL PREVENT THE AFFECTED PARTY FROM PERFORMING ITS OBLIGATIONS UNDER THESE TERMS.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">13) Indemnification</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">You agree to defend, indemnify, and hold harmless us, our affiliates, and their respective directors, officers, employees, and agents from and against all claims and expenses, including attorneys' fees, arising out of the use of the Services and/or the Software by you or your account or ID Data.</p><h3 style="color: #252B37; font-size: 18px; font-style: normal; font-weight: 700; line-height: 24px;"><strong style="font-weight: 700">14) Miscellaneous</strong></h3><p style="color: #717680;font-size: 16px;font-style: normal;font-weight: 400;line-height: 20px;">The Services are intended for use only in compliance with applicable laws, and you undertake to use them in accordance with all such applicable laws. Without derogating from the foregoing and from any other terms herein, you agree to comply with all applicable export laws and restrictions and regulations and agree that you will not export, or allow the export or re-export of the Services and/or the Software or any part of it in violation of any such restrictions, laws, or regulations.These Terms constitute the entire agreement of the parties with respect to the subject matter hereof, and supersede all previous written or oral agreements between the parties with respect to such subject matter.These Terms shall be construed in accordance with the laws of the Republic of Panama without regard to its conflict of laws rules. You agree that any legal action arising out of or relating to these Terms shall be filed exclusively in the competent courts of the Republic of Panama.No waiver by either party of any breach or default hereunder shall be deemed to be a waiver of any preceding or subsequent breach or default. The section headings used herein are for convenience only and shall not be given any legal import.If any provision in the Terms is held invalid or unenforceable, that provision shall be construed in a manner consistent with applicable law to reflect the original intent of the provision, and the remaining provisions of the Terms shall remain in full force and effect. Any failure to exercise or enforce any right or provision of the Terms shall not constitute a waiver of such right or provision.You agree that these Terms and our rights hereunder may be assigned, in whole or in part, by us or our affiliate to any third party, at our sole discretion, including an assignment in connection with a merger, acquisition, reorganization, or sale of substantially all of our assets, or otherwise, in whole or in part. You may not delegate, sublicense, or assign your rights under these Terms.</p></body></html>
''';

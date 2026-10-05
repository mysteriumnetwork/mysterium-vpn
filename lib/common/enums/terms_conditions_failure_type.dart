enum TermsConditionsFailureType {
  saving(
    // TODO(maz): localize
    title: "We couldn't save your acceptance",
    // TODO(maz): localize
    content:
        'Something went wrong while accepting the updated Terms & Conditions. Please try again to continue using Mysterium VPN.',
  ),
  loading(
    // TODO(maz): localize
    title: "We couldn't load the Terms & Conditions",
    // TODO(maz): localize
    content:
        'The updated Terms & Conditions need to be available for you to review before you can accept them. Please try again.',
  );

  const TermsConditionsFailureType({required this.title, required this.content});

  final String title;
  final String content;
}

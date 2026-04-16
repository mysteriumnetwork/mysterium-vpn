/// The three content-blocking modes available in the app.
enum BlockerType {
  none('None'),
  malware('Malware'),
  nsfwAndMalware('NSFW & Malware');

  const BlockerType(this.label);

  final String label;
}

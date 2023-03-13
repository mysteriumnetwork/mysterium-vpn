abstract class ApiService {
  Future<bool> setEmailCommunicationApproval({required bool approval});
  Future<bool> setNotificationsApproval({required bool approval});
  bool geNotificationsApproval();
  bool getEmailCommunicationApproval();
  Future<void> getApi();
}

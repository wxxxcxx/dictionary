import 'package:url_launcher/url_launcher.dart' as browser;

class OneDrive {
  final String clientId='72089a57-d9d0-41ba-b194-18b5020e40f1';
  final String scope='User.Read Files.ReadWrite.All';
  final String redirectUri='dictionary://onedrive/authorize';

  void authorize() {
    String url = 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=$clientId&scope=$scope&response_type=code&redirect_uri=$redirectUri';
    browser.launch(url);
  }
}

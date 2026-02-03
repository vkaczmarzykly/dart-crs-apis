import 'package:dart_crs_apis/screens/account_screen.dart';

void main() {
  AccountScreen accountScreen = AccountScreen();
  accountScreen.initializeStream();
  accountScreen.runChatBot();
}
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  //requestData();
  requestDataAsync();
}

Future<void> requestData() async {
  String url = 'https://gist.githubusercontent.com/vkaczmarzykly/c623ab0fff954574e1a1921f2ee542a2/raw/b51b66f7ab32073c375622c23daaaae2965a0dc4/accounts.json';
  Uri uri = Uri.parse(url);
  Future<Response> futureResponse = get(uri);
  futureResponse.then((response) {
    print(response.body);
    List<dynamic> listAccounts = jsonDecode(response.body);
    Map<String, dynamic> mapCarla = listAccounts.firstWhere(
      (element) => element['name'] == 'Carla',
    );
    print(mapCarla["balance"]);
  });
}

dynamic requestDataAsync() async {
  String url = 'https://gist.githubusercontent.com/vkaczmarzykly/c623ab0fff954574e1a1921f2ee542a2/raw/b51b66f7ab32073c375622c23daaaae2965a0dc4/accounts.json';
  Response response = await get(Uri.parse(url));
  print(json.decode(response.body)[0]);
}
import 'package:http/http.dart';
import 'package:dart_crs_apis/api-key-gist.dart';
import 'dart:convert';

void main() {
  //requestData();
  //requestDataAsync();
  sendDataAsync({
    "id": "NEW001",
    "name": "Vitor",
    "lastName": "Kaczmarzyk",
    "balance": 5000
  });
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

Future<List<dynamic>> requestDataAsync() async {
  String url = 'https://gist.githubusercontent.com/vkaczmarzykly/c623ab0fff954574e1a1921f2ee542a2/raw/b51b66f7ab32073c375622c23daaaae2965a0dc4/accounts.json';
  Response response = await get(Uri.parse(url));
  return jsonDecode(response.body);
}

Future<void> sendDataAsync(Map<String, dynamic> mapAccount) async {
  List<dynamic> listAccounts = await requestDataAsync();
  listAccounts.add(mapAccount);
  String content = json.encode(listAccounts);
  
  String url = "https://api.github.com/gists/c623ab0fff954574e1a1921f2ee542a2";

  Response response = await post(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $gistKey",
      "Accept": "application/vnd.github.v3+json"
    },
    body: json.encode({
      "description": "Updated accounts list",
      "public": true,
      "files": {
        "accounts.json": {
          "content": content
        }
      }
    })
  );
  print(response.statusCode);
}
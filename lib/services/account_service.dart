import 'dart:async';

import 'package:dart_crs_apis/api-key-gist.dart';
import 'package:dart_crs_apis/models/account.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  String url = "https://api.github.com/gists/c623ab0fff954574e1a1921f2ee542a2";

  Future<List<Account>> getAll() async {
    Response response = await get(Uri.parse(url));
    _streamController.add("${DateTime.now()} | Requisição de leitura.");

    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic =
        json.decode(mapResponse["files"]["accounts.json"]["content"]);

    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }

    return listAccounts;
  }

  addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $gistKey"},
      body: json.encode({
        "description": "account.json",
        "public": true,
        "files": {
          "accounts.json": {
            "content": content,
          }
        }
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | Requisição adição bem sucedida (${account.name}).");
          print("Sucesso");
    } else {
      _streamController
          .add("${DateTime.now()} | Requisição falhou (${account.name}).");
          print("Erro" + response.statusCode.toString());
    }
  }
}
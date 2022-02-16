import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _valueInitial = 'BRL';
  String _result = '';
  List<String> keys = [];
  var _mapResponse = {};

  _getListCurrencies() async {
    String url = 'https://blockchain.info/ticker';
    var uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    _mapResponse = json.decode(response.body);
    setState(() {
      keys = _mapResponse.keys.whereType<String>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _getListCurrencies();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
                value: _valueInitial,
                items: keys.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                      value: item, child: Text(item));
                }).toList(),
                onChanged: (String? selected) {
                  setState(() {
                    _valueInitial = selected!;
                  });
                }),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ElevatedButton(
                  onPressed: () {
                    _getListCurrencies();
                    setState(() {
                      _result = _mapResponse[_valueInitial].toString();
                    });
                  },
                  child: Text('Atualizar')),
            ),
            Text(_result)
          ],
        ),
      ),
    );
  }
}
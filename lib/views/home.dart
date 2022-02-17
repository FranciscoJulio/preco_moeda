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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/bitcoin.png'),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: DropdownButton<String>(
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
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange)),
                  onPressed: () {
                    _getListCurrencies();
                    setState(() {
                      _result = _mapResponse[_valueInitial]['buy'].toString();
                    });
                  },
                  child: Text('Atualizar')),
            ),
            Text(
              _result,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

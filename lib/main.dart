import 'dart:convert';

import 'package:api_call/src/shared/models/indexes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<IndexModel> indexes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Índices de Crédito",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text("Taxas de juros e alguns índices oficiais do Brasil",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal))
                ],
              ),
              const SizedBox(height: 32.0),
              FutureBuilder(
                  future: getIndexes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                              label: Expanded(
                                  child: Text("Nome",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          DataColumn(
                              label: Expanded(
                                  child: Text("Valor",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                        ],
                        rows: indexes
                            .map((index) => DataRow(cells: [
                                  DataCell(Text(index.nome)),
                                  DataCell(Text('${index.valor} %'))
                                ]))
                            .toList(),
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<IndexModel>> getIndexes() async {
    final response =
        await http.get(Uri.parse('https://brasilapi.com.br/api/taxas/v1'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        indexes.add(IndexModel.fromJson(index));
      }

      return indexes;
    }

    return indexes;
  }
}

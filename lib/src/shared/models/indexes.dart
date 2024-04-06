import 'dart:convert';

List<IndexModel> indexModelFromJson(String str) => List<IndexModel>.from(
    json.decode(str).map((index) => IndexModel.fromJson(index)));

String indexModelToJson(List<IndexModel> data) =>
    json.encode(List<dynamic>.from(data.map((index) => index.toJson())));

class IndexModel {
  String nome;
  double valor;

  IndexModel({required this.nome, required this.valor});

  factory IndexModel.fromJson(Map<String, dynamic> json) =>
      IndexModel(nome: json['nome'], valor: json['valor']);

  Map<String, dynamic> toJson() => {"nome": nome, "valor": valor};
}

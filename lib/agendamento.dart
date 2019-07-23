class Agendamento {
  num id;
  final String nome;
  final DateTime data;
  bool uploaded = false;

  Agendamento(this.nome, this.data);

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'data': data.toString(),
    };
  }

  @override
  String toString() {
    return 'Agendamento: $nome - ${data.toString()}';
  }
}

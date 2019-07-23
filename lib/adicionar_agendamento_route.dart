import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'agendamento.dart';
import 'agendamento_dao.dart';

class AdicionarAgendamentoRoute extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();

  @override
  _AdicionarAgendamentoRouteState createState() =>
      _AdicionarAgendamentoRouteState();
}

class _AdicionarAgendamentoRouteState extends State<AdicionarAgendamentoRoute> {
  String _nome;
  DateTime _data;

  @override
  void initState() {
    _data = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future saveForm() async {
      AdicionarAgendamentoRoute._formKey.currentState.save();
      Agendamento agendamento = Agendamento(
        _nome,
        _data,
      );
      print('Saving...$agendamento');
      AgendamentoDao dao = AgendamentoDao();
      dao.insertAgendamento(agendamento);
      Navigator.pop(context, agendamento);
    }

    void callbackData(data) {
      _data = data;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Agendamento"),
      ),
      body: Form(
        key: AdicionarAgendamentoRoute._formKey,
        child: Container(
          margin: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: getInputDecoration('Nome', 'Fulano da Silva'),
                validator: (value) {
                  return value.isEmpty ? "Campo obrigatório!" : null;
                },
                onSaved: (value) => _nome = value,
              ),
              DateForm(callbackData),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      if (AdicionarAgendamentoRoute._formKey.currentState
                          .validate()) {
                        saveForm();
                      }
                    },
                    color: Theme.of(context).accentColor,
                    child: Text("Adicionar"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration getInputDecoration(String label, String hintText) {
    return InputDecoration(
      labelText: '$label',
      hintText: '$hintText',
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1))),
      alignLabelWithHint: true,
    );
  }
}

class DateForm extends StatefulWidget {
  final Function callback;

  DateForm(this.callback);

  @override
  _DateFormState createState() => _DateFormState();
}

class _DateFormState extends State<DateForm> {
  DateTime _dateNow;
  DateTime _dataSelecionada;
  DateTime _lastDate;

  @override
  void initState() {
    this._dataSelecionada = DateTime.now();
    this._dateNow = new DateTime(
        _dataSelecionada.year, _dataSelecionada.month, _dataSelecionada.day);
    this._lastDate = DateTime(2020);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        title: Text("Data"),
        subtitle: Text(DateFormat('dd/MM/yyyy').format(_dataSelecionada)),
        leading: Icon(Icons.calendar_today),
        onTap: () => _pickDate(),
      ),
    );
  }

  _pickDate() {
    showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: _dateNow,
      lastDate: _lastDate,
    ).then((value) {
      setState(() {
        _dataSelecionada = value ?? _dataSelecionada;
        widget.callback(_dataSelecionada);
      });
    });
  }
}

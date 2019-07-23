import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'adicionar_agendamento_route.dart';
import 'agendamento.dart';
import 'agendamento_dao.dart';

void main() {
  runApp(new ListaAgendamentos());
}

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Color(0xFF673AB7),
    accentColor: Color(0xFFFF9800),
    dividerColor: Color(0xFFBDBDBD),
    primaryColorLight: Color(0xFFD1C4E9),
    primaryColorDark: Color(0xFF512DA8),
  );
}

class ListaAgendamentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Lista Agendamentos",
      home: Agendamentos(),
      theme: appTheme(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt'),
      ],
    );
  }
}

class Agendamentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Lista Agendamentos")),
      body: ListaStream(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdicionarAgendamentoRoute()))
            .then((value) {
          print("Back to main! + $value");
        }),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Agendamentos"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: Text("Favoritos"),
          )
        ],
        onTap: (i) {
          print(i);
          switch (i) {
            case 0:
              break;
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Teste"),
                  ),
                  body: Container(),
                );
              }));
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class ListaStream extends StatefulWidget {
  @override
  _ListaStreamState createState() => _ListaStreamState();
}

class _ListaStreamState extends State<ListaStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              Agendamento agendamento = snapshot.data[i];
//              print("Displaying: $agendamento");
              return ListTile(
                title: Text("${agendamento.nome}"),
                subtitle: Text(
                    "${DateFormat('dd/MM/yyyy').format(agendamento.data)}"),
                leading: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColorLight,
                ),
                onTap: () {
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                value: null,
              ),
            ),
          );
        }
      },
      stream: AgendamentoDao().getAgendamentos().asStream(),
    );
  }
}

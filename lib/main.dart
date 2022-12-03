import 'package:calc_imc_n3/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAXtTY58mumWY6MMa1Ei_KMb0c-Q900dVc",
      appId: "1:150895113269:android:ef72d8e473f2856a94ed7c",
      messagingSenderId: "150895113269",
      projectId: "calculadoimc",
    ),
  );
  runApp(MaterialApp(
    home: HomeScreen(),
    theme: ThemeData.light(),
  ));
}

String _result = "";

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Calcule seu IMC';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

TextEditingController controllerPeso = TextEditingController();
TextEditingController controllerAltura = TextEditingController();
TextEditingController controllerNome = TextEditingController();

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  int? status;

  void sendData(double imc, double peso, double altura, String nome) {
    FirebaseFirestore.instance.collection("Pesagens").add(
      {
        "altura": altura,
        "peso": peso,
        "imc": imc,
        "nome": nome,
        "data": Timestamp.now()
      }
    );
  }

  void calculateImc() {
    double peso = double.parse(controllerPeso.text);
    double altura = double.parse(controllerAltura.text) / 100.0;
    double imc = peso / (altura * altura);
    String nome = controllerNome.text.toString();

    setState(() {
      _result = "IMC = ${imc.toStringAsPrecision(2)}\n";
      if (imc < 18.6)
        _result += "Abaixo do peso";
      else if (imc < 25.0)
        _result += "Peso ideal";
      else if (imc < 30.0)
        _result += "Levemente acima do peso";
      else if (imc < 35.0)
        _result += "Obesidade Grau I";
      else if (imc < 40.0)
        _result += "Obesidade Grau II";
      else
        _result += "Obesidade Grau IIII";
    });

    sendData(imc, peso, altura, nome);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllerNome,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.blue),
              ),
              border: OutlineInputBorder(),
              labelText: 'Insira seu nome aqui',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllerPeso,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.blue),
              ),
              border: OutlineInputBorder(),
              labelText: 'Insira seu peso aqui',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllerAltura,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.blue),
              ),
              border: OutlineInputBorder(),
              labelText: 'Insira sua altura aqui',
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            alignment: Alignment.center,
              backgroundColor: Colors.red,
              elevation: 0,
              shadowColor: Colors.green),
          child: Text(
            'Calcular',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            calculateImc();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        SizedBox(
          height: 8.0,
        ),
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              elevation: 0,
              shadowColor: Colors.green),
          child: Text(
            'Voltar',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 36.0),
          child: Text(
            _result,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}



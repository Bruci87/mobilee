import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<CalculatorData>(
      create: (context) => CalculatorData(),
      builder: (context, child) => MaterialApp(home: WidgetPrincipal()),
    ),
  );
}

class CalculatorData extends ChangeNotifier {
  double x = 0;
  double y = 0;
  double resultado = 0;

  void setX(double value) {
    x = value;
    notifyListeners();
  }

  void setY(double value) {
    y = value;
    notifyListeners();
  }

  void calcular() {
    resultado = x + y;
    notifyListeners();
  }
}

class WidgetPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case "/preenche":
            builder = (BuildContext context) => ScaffoldPreenche();
            break;
          case "/input":
            final args = settings.arguments as Map<String, dynamic>;
            builder = (BuildContext context) => ScaffoldInput();
            break;
          default:
            builder = (BuildContext context) => ScaffoldHome();
        }
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}

class ScaffoldHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora App")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed("/preenche"),
          child: Text("Ir para Calculadora"),
        ),
      ),
    );
  }
}

class ScaffoldPreenche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora"), backgroundColor: Colors.amber),
      body: Consumer<CalculatorData>(
        builder: (context, data, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("X: ${data.x}  "),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context)
                              .pushNamed("/input", arguments: {'type': 'X'}),
                      child: Text("Informar X"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Y: ${data.y}  "),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context)
                              .pushNamed("/input", arguments: {'type': 'Y'}),
                      child: Text("Informar Y"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => data.calcular(),
                  child: Text("Calcular"),
                ),
                SizedBox(height: 10),
                Text(
                  "Resultado: ${data.resultado}",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ScaffoldInput extends StatefulWidget {
  @override
  State<ScaffoldInput> createState() => _ScaffoldInputState();
}

class _ScaffoldInputState extends State<ScaffoldInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<CalculatorData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text("Set widget")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Valor",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              double val = double.tryParse(_controller.text) ?? 0.0;
              data.setX(val);
              data.setY(val);

              Navigator.of(context).pop();
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }
}

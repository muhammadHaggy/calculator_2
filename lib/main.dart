import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
          key: Key("homePage"), title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MaterialColor _primarySwatchColor = Colors.orange;
  final Color _titleAppBarColor = Colors.white;
  final sbValue = StringBuffer();

  @override
  void initState() {
    super.initState();
    sbValue.write("0");
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  void appendNumber(String strInput) => setState(() {
        if (sbValue.toString() == '0') {
          sbValue.clear();
        }
        sbValue.write(strInput);
      });

  void appendOperator(String operator) => setState(() {
        if (sbValue.toString() != '0') {
          sbValue.write(operator);
        }
      });

  void evaluate() => setState(() {
        ContextModel cm = ContextModel();
        Parser parser = Parser();
        Expression exp = parser.parse(sbValue.toString());
        sbValue.clear();
        sbValue.write(exp.evaluate(EvaluationType.REAL, cm).toString());
      });

  void backspace() => setState(() {
        String temp = sbValue.toString();
        sbValue.clear();
        if (temp.length > 1) {
          sbValue.write(temp.substring(0, temp.length - 1));
        }
        if (sbValue.toString() == '') {
          sbValue.write('0');
        }
      });

  Widget buttonBuilder(String text, Function() onPressed, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: TextButton(
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline4,
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: _primarySwatchColor),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Basic Calculator",
            style: TextStyle(color: _titleAppBarColor),
          ),
        ),
        body: Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomRight,
                key: const Key("expanded_container_bagian_atas"),
                // child: Stack(
                //   alignment: Alignment.bottomRight,
                //   children: [
                //     AutoSizeText(
                //       sbValue.toString(),
                //       style: Theme.of(context).textTheme.headline2,
                //       maxLines: 1,
                //     )
                //   ],
                // ),
                child: AutoSizeText(
                  sbValue.toString(),
                  style: Theme.of(context).textTheme.headline2,
                  maxLines: 1,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                key: UniqueKey(),
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buttonBuilder(
                          'C',
                          () {
                            sbValue.clear();
                            appendNumber('0');
                          },
                          flex: 2,
                        ),
                        Expanded(
                          child: TextButton(
                            child: const Icon(
                              Icons.backspace,
                              color: Colors.grey,
                            ),
                            onPressed: () => backspace(),
                          ),
                        ),
                        buttonBuilder('/', () => appendOperator('/')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buttonBuilder('7', () => appendNumber('7')),
                        buttonBuilder('8', () => appendNumber('8')),
                        buttonBuilder('9', () => appendNumber('9')),
                        buttonBuilder('*', () => appendOperator('*')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buttonBuilder('4', () => appendNumber('4')),
                        buttonBuilder('5', () => appendNumber('5')),
                        buttonBuilder('6', () => appendNumber('6')),
                        buttonBuilder('-', () => appendOperator('-')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buttonBuilder('1', () => appendNumber('1')),
                        buttonBuilder('2', () => appendNumber('2')),
                        buttonBuilder('3', () => appendNumber('3')),
                        buttonBuilder('+', () => appendOperator('+')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buttonBuilder(
                          '0',
                          () => appendNumber('0'),
                          flex: 3,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: Text(
                              '=',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            onPressed: () => evaluate(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

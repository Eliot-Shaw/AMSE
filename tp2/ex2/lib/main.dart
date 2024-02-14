import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentSliderPrimaryValue = 0.5;
  double _currentSliderSecondaryValue = 0.5;
  double _currentSliderThirdValue = 0.5;
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slider')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(_currentSliderSecondaryValue)
                ..rotateZ(-math.pi / _currentSliderPrimaryValue)
                ..scale(_currentSliderThirdValue),
              child: Image.asset('assets/images/wallebra.png'),
            ),
          ),
          Row(children: [
            const Text('Rotation X : '),
            Expanded(
                child: Slider(
              value: _currentSliderPrimaryValue,
              label: _currentSliderPrimaryValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderPrimaryValue = value;
                });
              },
            )),
          ]),
          Row(
            children: [
              const Text('Rotation Z : '),
              Expanded(
                  child: Slider(
                value: _currentSliderSecondaryValue,
                label: _currentSliderSecondaryValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderSecondaryValue = value;
                  });
                },
              ))
            ],
          ),
          Row(
            children: [
              const Text('Mirror : '),
              Checkbox(
                value: checkboxValue,
                onChanged: (bool? value) {
                  setState(() {
                    checkboxValue = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Scale : '),
              Expanded(
                  child: Slider(
                value: _currentSliderThirdValue,
                label: _currentSliderThirdValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderThirdValue = value;
                  });
                },
              ))
            ],
          ),
        ],
      ),
    );
  }
}

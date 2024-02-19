import 'package:flutter/material.dart';

class Ex2 extends StatelessWidget {
  static const String nomExercice = "Transformer une image";

  const Ex2({super.key});
  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(Ex2.nomExercice),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(_currentSliderSecondaryValue)
                ..rotateZ(6.2831853072*_currentSliderPrimaryValue)
                ..scale(
                    checkboxValue
                        ? -_currentSliderThirdValue
                        : _currentSliderThirdValue,
                    _currentSliderThirdValue),
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

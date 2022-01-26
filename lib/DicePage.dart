import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

import 'model/Dice.dart';

class DicePage extends StatefulWidget {
  const DicePage({Key? key}) : super(key: key);

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  //dices
  int numberOfDice = 2;
  List<Dice> dices = [
    Dice(Random().nextInt(6) + 1),
    Dice(Random().nextInt(6) + 1)
  ];
  int resultOfDice = 0;

  AudioCache audioCache = AudioCache();

  //menu item list
  static List<int> menuItems = List<int>.generate(10, (int index) => index + 1);
  final List<DropdownMenuItem<int>> dropDownMenuItem = menuItems
      .map((e) => DropdownMenuItem<int>(value: e, child: Text(e.toString())))
      .toList();

  @override
  void initState() {
    super.initState();
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      RollingAllDice();
    });
    resultOfDice = ResultOfDice(dices);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
          const Text("Choisir le nombre de dés  "),
          DropdownButton(
              value: numberOfDice,
              items: dropDownMenuItem,
              onChanged: (int? value) {
                numberOfDice = value!;
                setState(() {
                  refreshDiceList();
                });
              })
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              style: numberOfDice > 1
                  ? const ButtonStyle()
                  : ElevatedButton.styleFrom(primary: Colors.grey),
              onPressed: () {
                if (numberOfDice > 1) {
                  numberOfDice--;
                  setState(() {
                    refreshDiceList();
                  });
                }
              },
              child: const Icon(Icons.remove)),
          ElevatedButton(
              style: numberOfDice < 10
                  ? const ButtonStyle()
                  : ElevatedButton.styleFrom(primary: Colors.grey),
              onPressed: () {
                if (numberOfDice < 10) {
                  numberOfDice++;
                  setState(() {
                    refreshDiceList();
                  });
                }
              },
              child: const Icon(Icons.add))
        ]),
        Text("Résultat : $resultOfDice"),
        Expanded(
            child: OrientationBuilder(
                builder: (context, orientation) => GridView.count(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 6,
                      mainAxisSpacing: 10,
                      children: [
                        for (int cpt = 0; cpt < numberOfDice; cpt++)
                          MyAnimatedDice(cpt),
                      ],
                    ))),
        /*
        Expanded(
            child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 120,
          mainAxisSpacing: 10,
          children: [
            for (int cpt = 0; cpt < numberOfDice; cpt++) MyAnimatedDice(cpt),
          ],
        )),*/
        IconButton(onPressed: () => RollingAllDice(), icon: const Icon(Icons.circle))
      ],
    );
  }

  AnimatedContainer MyAnimatedDice(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      transform: Transform(
        transform: Matrix4.identity()
          /*
          does not work with android
          ..translate(
              dices[index].isAnimated == true ? Random().nextDouble() * -10 : 0,
              dices[index].isAnimated == true ? Random().nextDouble() * -20 : 0)*/
          ..rotateX(dices[index].isAnimated == true ? 45 : 0),
      ).transform,
      child: TextButton(
        child: Image.asset("assets/images/dice${dices[index].value}.png"),
        onPressed: () => RollingDice(index),
      ),
    );
  }

  Future<void> RollingDice(int index) async {
    audioCache.play("../assets/sounds/rolling-dice.wav");
    for (int cpt = 0; cpt < 10; cpt++) {
      await Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          dices[index].isAnimated = !dices[index].isAnimated;
          dices[index].value = Random().nextInt(6) + 1;
        });
      });
    }
    dices[index].isAnimated = false;
    resultOfDice = ResultOfDice(dices);
  }

  Future<void> RollingAllDice() async {
    audioCache.play("../assets/sounds/rolling-dice.wav");
    for (int cpt = 0; cpt < 10; cpt++) {
      await Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          for (int idx = 0; idx < dices.length; idx++) {
            dices[idx].isAnimated = !dices[idx].isAnimated;
            dices[idx].value = Random().nextInt(6) + 1;
          }
        });
      });
    }
    for (int idx = 0; idx < dices.length; idx++) {
      dices[idx].isAnimated = false;
    }
    resultOfDice = ResultOfDice(dices);
  }

  void refreshDiceList() {
    dices.clear();
    for (int cpt = 0; cpt < numberOfDice; cpt++) {
      dices.add(Dice(Random().nextInt(6) + 1));
    }
    resultOfDice = ResultOfDice(dices);
  }

  int ResultOfDice(List<Dice> dicesList) {
    int result = 0;
    for (Dice dice in dicesList) {
      result += dice.value;
    }
    return result;
  }
}

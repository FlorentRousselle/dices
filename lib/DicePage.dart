import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'model/Dice.dart';

class DicePage extends StatefulWidget {
  const DicePage({Key? key}) : super(key: key);

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  //dices
  int numberOfDice = 2;
  List<Dice> dices = [Dice(Random().nextInt(6) + 1), Dice(Random().nextInt(6) + 1)];
  int resultOfDice = 0;

  AudioCache audioCache = AudioCache();

  //menu item list
  static const menuItems = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final List<DropdownMenuItem<int>> dropDownMenuItem = menuItems
      .map((e) => DropdownMenuItem<int>(value: e, child: Text(e.toString())))
      .toList();

  @override
  void initState() {
    super.initState();
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
                setState(() {
                  numberOfDice = value!;
                  dices.clear();
                  for (int cpt = 0; cpt < numberOfDice; cpt++) {
                    dices.add(Dice(Random().nextInt(6) + 1));
                  }
                  resultOfDice = ResultOfDice(dices);
                });
              })
        ]),
        Text("Résultat : $resultOfDice"),
        Expanded(
            child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 100,
          mainAxisSpacing: 10,
          children: [
            for(int cpt = 0; cpt < numberOfDice; cpt++) MyAnimatedDice(cpt),
          ],
        )),
        IconButton(
            onPressed: () => Rolling2Dice(), icon: Icon(Icons.circle))
      ],
    );
  }

  AnimatedContainer MyAnimatedDice(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      transform: Transform.translate(
        offset: Offset(
            dices[index].isAnimated == true ? Random().nextDouble() * -10 : 0,
            dices[index].isAnimated == true ? Random().nextDouble() * -10 : 0),
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

  Future<void> Rolling2Dice() async {
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

  int ResultOfDice(List<Dice> dicesList) {
    int result = 0;
    for (Dice dice in dicesList) {
      result += dice.value;
    }
    return result;
  }
}

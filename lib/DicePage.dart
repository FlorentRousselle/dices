import 'dart:math';

import 'package:flutter/material.dart';

class DicePage extends StatefulWidget {
  const DicePage({Key? key}) : super(key: key);

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  List<int> dices = [Random().nextInt(6) + 1, Random().nextInt(6) + 1];
  List<bool> animatedDices = [false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: MyAnimatedDice(0)
              ),
              Expanded(
                child: MyAnimatedDice(1),
              ),
            ],
          )),
          IconButton(
              onPressed: () => Rolling2Dice(), icon: Icon(Icons.reset_tv))
        ],
      ),
    );
  }

  AnimatedContainer MyAnimatedDice(int index) {
    return AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                transform: Transform.translate(
                  offset: Offset(animatedDices[index] == true ? Random().nextDouble()*-10 : 0, animatedDices[index] == true ? Random().nextDouble()*-10 : 0),
                ).transform,
                child: TextButton(
                  child: Image.asset("assets/images/dice${dices[index]}.png"),
                  onPressed: () => RollingDice(index),
                ),
              );
  }

  Future<void> RollingDice(int index) async {
    for (int cpt = 0; cpt < 10; cpt++) {
      await Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          animatedDices[index] = !animatedDices[index];
          dices[index] = Random().nextInt(6) + 1;
        });
      });
    }
    animatedDices[index] = false;
  }

  Future<void> Rolling2Dice() async {
    for (int cpt = 0; cpt < 10; cpt++) {
      await Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          for(int idx = 0; idx < dices.length; idx++){
            animatedDices[idx] = !animatedDices[idx];
            dices[idx] = Random().nextInt(6) + 1;
          }
        });
      });
    }
    for(int idx = 0; idx < dices.length; idx++){
      animatedDices[idx] = false;
    }
  }
}

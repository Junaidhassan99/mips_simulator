import 'package:flutter/material.dart';
import 'package:mips_simulator/models/instruction.dart';
import 'package:mips_simulator/utilities/translation_utilties.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Create an integer list of length 31 will be used as registers
  List<int> x = List.filled(31, 0);

  @override
  Widget build(BuildContext context) {
    //testing

    String exampleInstructionR = 'addi \$t1, \$s3, 16';
    String exampleInstructionI1 = 'bne \$t0, \$s5, Exit';
    String exampleInstructionI2 = 'bgtz \$t9, Exit';
    String exampleInstructionJ = 'j Loop';

    Instruction instruction =
        TranslationUtilities.decoder(exampleInstructionI2);

    print(instruction.funct);
    print(instruction.instructionAddress);
    print(instruction.jumpAddress);
    print(instruction.op_code);
    print(instruction.rd);
    print(instruction.rs);
    print(instruction.rt);
    print(instruction.shift);
    print(instruction.type);
    print(instruction.value);

    //print(exampleInstructionR);
    //
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 500,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

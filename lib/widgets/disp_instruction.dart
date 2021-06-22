import 'package:flutter/material.dart';
import 'package:mips_simulator/models/instruction.dart';

class DispInstruction extends StatelessWidget {
  final Instruction instruction;
  const DispInstruction(this.instruction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(instruction.funct.toString()),
        Divider(),
      ],
    );
  }
}

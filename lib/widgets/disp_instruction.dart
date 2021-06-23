import 'package:flutter/material.dart';
import 'package:mips_simulator/models/instruction.dart';
import 'package:mips_simulator/utilities/translation_utilties.dart';

class DispInstruction extends StatelessWidget {
  final Instruction instruction;
  const DispInstruction(this.instruction, {Key? key}) : super(key: key);

  String _nullhandler(String? text) {
    return text ?? '---';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Text(
            'Machine Code: ${TranslationUtilities.decodeAccordingToType(instruction)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Instruction Address: 0x${_nullhandler(instruction.instructionAddress)}"),
                  Text("OP-Code: ${_nullhandler(instruction.op_code)}"),
                  Text("Shift: ${_nullhandler(instruction.shift)}"),
                  Text("Funct: ${_nullhandler(instruction.funct)}"),
                  Text(
                      "Instruction Type: ${_nullhandler(instruction.type.toUpperCase())}"),
                  Text("RS: ${_nullhandler(instruction.rs)}"),
                  Text("RT: ${_nullhandler(instruction.rt)}"),
                  Text("RD: ${_nullhandler(instruction.rd)}"),
                  //Text("Value: ${_nullhandler(instruction.value)}"),
                  Text("Target Address: ${_nullhandler(instruction.target)}"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result: ${_nullhandler(instruction.result)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

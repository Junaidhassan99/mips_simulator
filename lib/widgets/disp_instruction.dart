import 'package:flutter/material.dart';
import 'package:mips_simulator/models/instruction.dart';
import 'package:mips_simulator/utilities/translation_utilties.dart';

class DispInstruction extends StatelessWidget {
  final Instruction instruction;
  final int numberOfLines;
  const DispInstruction(this.instruction, this.numberOfLines, {Key? key})
      : super(key: key);

  String _nullHandler(String? text) {
    return text ?? '---';
  }

  String _nullHandlerForTarget(String? text, bool mIsTargetValue) {
    if (text == null) {
      return '---';
    } else if (mIsTargetValue) {
      return text;
    } else {
      return '0x' + text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Text(
            'Machine Code: ${TranslationUtilities.decodeAccordingToType(instruction, numberOfLines)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Instruction Address: 0x${_nullHandler(instruction.instructionAddress)}"),
                  Text("OP-Code: ${_nullHandler(instruction.op_code)}"),
                  Text("Shift: ${_nullHandler(instruction.shift)}"),
                  Text("Funct: ${_nullHandler(instruction.funct)}"),
                  Text(
                      "Instruction Type: ${_nullHandler(instruction.type.toUpperCase())}"),
                  Text("RS: ${_nullHandler(instruction.rs)}"),
                  Text("RT: ${_nullHandler(instruction.rt)}"),
                  Text("RD: ${_nullHandler(instruction.rd)}"),
                  //Text("Value: ${_nullhandler(instruction.value)}"),
                  Text(
                      "Target / Immediate Address: ${_nullHandlerForTarget(instruction.target, instruction.isTargetAValue)}"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result: ${_nullHandler(instruction.result)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}

import 'package:mips_simulator/enums.dart';
import 'package:mips_simulator/models/instruction.dart';

class TranslationUtilities {
  static String checkTypeOfInstruction(String op_code) {
    if (op_code == '000000') {
      return 'r';
    } else if (op_code == '000010' || op_code == '000011') {
      return 'j';
    } else {
      return 'i';
    }
  }

  //number is always in int
  static String decimalToBinary(int number) {
    return number.toRadixString(2);
  }

  //binary is always in string
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }

  static Map<String, String?> translateToGetFunctAndOpMachineCode(
      String instruction) {
    //6-bit
    String? op_code;
    //6-bit
    String? funct;

    switch (instruction) {

      //R-Type
      case 'add':
        {
          op_code = '000000';
          funct = '100000';
          break;
        }
      case 'addi':
        {
          op_code = '000000';
          funct = '001000';
          break;
        }
      case 'div':
        {
          op_code = '000000';
          funct = '011010';
          break;
        }
      case 'mult':
        {
          op_code = '000000';
          funct = '011000';
          break;
        }

      //I-Type

      case 'beq':
        {
          op_code = '000100';
          funct = null;
          break;
        }
      case 'bgtz':
        {
          op_code = '000111';
          funct = null;
          break;
        }
      case 'blez':
        {
          op_code = '000110';
          funct = null;
          break;
        }
      case 'bne':
        {
          op_code = '000101';
          funct = null;
          break;
        }

      //J-Type

      case 'j':
        {
          op_code = '000010';
          funct = null;
          break;
        }

      //Error

      default:
        {
          op_code = null;
          funct = null;
        }
    }

    return {
      'op': op_code,
      'fn': funct,
    };
  }

  static List<String> _avalibleRegisters = [
    'r0',
    'at',
    'v0',
    'v1',
    'a0',
    'a1',
    'a2',
    'a3',
    't0',
    't1',
    't2',
    't3',
    't4',
    't5',
    't6',
    't7',
    's0',
    's1',
    's2',
    's3',
    's4',
    's5',
    's6',
    's7',
    't8',
    't9',
    'k0',
    'k1',
    'gp',
    'sp',
    's8',
    'ra',
  ];

  static int getRegisterSerial(String name) {
    return _avalibleRegisters.indexOf(name);
  }

  static String getRegisterName(int decimalCode) {
    return _avalibleRegisters[decimalCode];
  }

  static Instruction? convertStringInstructionToObject(
      String stringInstruction) {
    Instruction? instruction;
    return instruction;
  }
}

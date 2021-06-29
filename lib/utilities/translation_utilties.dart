import 'package:mips_simulator/enums.dart';
import 'package:mips_simulator/models/instruction.dart';
import 'package:intl/intl.dart';

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

  static List<String> getHexAddressesOfLength(int n) {
    List<String> resultList = [];
    String currentHexAddress = '00400000';
    resultList.add(currentHexAddress);

    for (int i = 0; i < n; i++) {
      currentHexAddress = incrementHexAddress(currentHexAddress);
      resultList.add(currentHexAddress);
    }

    return resultList;
  }

  static String decodeAccordingToType(Instruction instruction, int n) {
    final List<String> instructionAddressesList = getHexAddressesOfLength(n);

    String? targetIfAny = '${instruction.target}';
    if (instruction.target != null && !instruction.isTargetAValue) {
      targetIfAny = '(0x$targetIfAny)';
    }

    if (instruction.type == 'r') {
      return "${instruction.op_code} ${instruction.rs} ${instruction.rt} ${instruction.rd} ${instruction.shift} ${instruction.funct}";
    } else if (instruction.type == 'j') {
      //Convert Hex Target to Binary
      //Drop first 4 bits
      //Drop last 2 bits
      //instruction.target is directly being used
      targetIfAny = fillBinaryString(hexToBinary(instruction.target!), 32)
          .substring(4, 30);

      //For testing
      // print(targetIfAny);
      // print(targetIfAny.length);

      return "${instruction.op_code} $targetIfAny";
    } else {
      if (!instruction.isTargetAValue) {
        //branch-index - (current-index + 1)
        //j - (c + 1)

        int j = instructionAddressesList.indexOf(instruction.target!);
        int c =
            instructionAddressesList.indexOf(instruction.instructionAddress);
        int offset = j - (c + 1);

        String binaryResult = '';

        if (offset >= 0) {
          binaryResult = decimalToBinary(offset);
        } else {
          //Finding 2's complement of conversion
          decimalToBinary(offset).split('').forEach((element) {
            if (element == '0') {
              element = '1';
            } else {
              element = '0';
            }

            binaryResult += element;
          });

          binaryResult = decimalToBinary(binaryToDecimal(binaryResult) + 1);
        }

        targetIfAny = fillBinaryString(binaryResult, 16);
      }

      return "${instruction.op_code} ${instruction.rs} ${instruction.rt} $targetIfAny";
    }
  }

  static Map<String, dynamic> execute(List<int> mX, Instruction instruction) {
    bool mIsJumpAllowed = false;
    String resultString;

    if (instruction.type == 'r') {
      int a = mX[binaryToDecimal(instruction.rs!)];
      int b = mX[binaryToDecimal(instruction.rt!)];

      int result = 0;

      switch (instruction.funct) {
        //add
        case '100000':
          {
            result = a + b;
            break;
          }
        //sub
        case '100010':
          {
            result = a - b;
            break;
          }
        //mult
        case '011000':
          {
            result = a * b;
            break;
          }
        default:
          {
            print('error');
            break;
          }
      }

      if (instruction.funct != '011000') {
        mX[binaryToDecimal(instruction.rd!)] = result;
      }
      resultString = result.toString();
    } else if (instruction.type == 'j') {
      String result = '';
      switch (instruction.op_code) {
        case '000010':
          {
            result = 'Jump to ${instruction.target}';
            mIsJumpAllowed = true;
            break;
          }
        default:
          {
            print('error');
          }
      }

      resultString = result;
    } else {
      int a = mX[binaryToDecimal(instruction.rs!)];
      int b = mX[binaryToDecimal(instruction.rt!)];

      String result = '';
      switch (instruction.op_code) {

        //beq
        case '000100':
          {
            bool resultCompare = (a == b);
            result = resultCompare.toString();
            mIsJumpAllowed = resultCompare;
            break;
          }
        //bne
        case '000101':
          {
            bool resultCompare = (a != b);
            result = resultCompare.toString();
            mIsJumpAllowed = resultCompare;
            break;
          }
        //bgtz
        case '000111':
          {
            bool resultCompare = (a > 0);
            result = resultCompare.toString();
            mIsJumpAllowed = resultCompare;
            break;
          }
        //blez
        case '000110':
          {
            bool resultCompare = (a <= 0);
            result = resultCompare.toString();
            mIsJumpAllowed = resultCompare;
            break;
          }
        //addi
        case '001000':
          {
            result = (b + binaryToDecimal(instruction.target!)).toString();
            mX[binaryToDecimal(instruction.rs!)] = int.parse(result);

            break;
          }
        default:
          {
            print('error');
          }
      }
      resultString = result;
    }
    return {'res': resultString, 'ija': mIsJumpAllowed};
  }

  //number is always in int
  static String decimalToBinary(int number) {
    return number.toRadixString(2);
  }

  //binary is always in string
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }

  static String hexToBinary(String hexCode) {
    int decimalForm = int.parse(hexCode, radix: 16);
    String binaryForm = decimalToBinary(decimalForm);
    return binaryForm;
  }

  static String incrementHexAddress(String previousHexCode) {
    //print(previousHexCode);
    //convert hex to int
    int dec = int.parse(previousHexCode, radix: 16);
    //increment by 4
    dec += 4;
    //convert back to hex
    previousHexCode = dec.toRadixString(16);

    return fillBinaryString(previousHexCode, 8);
  }

  static String fillBinaryString(String binaryString, int size) {
    return binaryString.padLeft(size, '0');
  }

  static Map<String, String?> translateToGetFunctAndOpMachineCode(
      String instruction) {
    //6-bit
    String? op_code;
    //6-bit
    String? funct;
    //6-bit
    String? shift;

    switch (instruction) {

      //R-Type
      case 'add':
        {
          op_code = '000000';
          funct = '100000';
          shift = '000000';
          break;
        }

      case 'sub':
        {
          op_code = '000000';
          funct = '100010';
          shift = '000000';
          break;
        }
      case 'mult':
        {
          op_code = '000000';
          funct = '011000';
          shift = '000000';
          break;
        }

      //I-Type
      case 'addi':
        {
          op_code = '001000';
          funct = null;
          shift = null;
          break;
        }

      case 'beq':
        {
          op_code = '000100';
          funct = null;
          shift = null;
          break;
        }
      case 'bgtz':
        {
          op_code = '000111';
          funct = null;
          shift = null;
          break;
        }
      case 'blez':
        {
          op_code = '000110';
          funct = null;
          shift = null;
          break;
        }
      case 'bne':
        {
          op_code = '000101';
          funct = null;
          shift = null;
          break;
        }

      //J-Type

      case 'j':
        {
          op_code = '000010';
          funct = null;
          shift = null;
          break;
        }

      //Error

      default:
        {
          op_code = null;
          funct = null;
          shift = null;
        }
    }

    return {
      'op': op_code,
      'fn': funct,
      'st': shift,
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

  static Instruction decoder(String stringInstruction) {
    Instruction instruction =
        Instruction(type: 'r', op_code: '000000', instructionAddress: '0000');

    String temp = stringInstruction;
    String head = temp.substring(0, temp.indexOf(' '));
    temp = temp.substring(temp.indexOf(' '), temp.length).trim();

    Map<String, String?> functAndOp = translateToGetFunctAndOpMachineCode(head);

    instruction.type = checkTypeOfInstruction(functAndOp['op']!);

    // print(instruction.type);

    //print('head:$head');
    // print('temp:$temp');

    instruction.op_code = functAndOp['op']!;

    if (instruction.type == 'r') {
      instruction.funct = functAndOp['fn']!;

      instruction.shift = functAndOp['st']!;
    }

    if (instruction.type == 'r') {
      switch (instruction.funct) {
        //add
        case '100000':
        //sub
        case '100010':
          {
            //rd
            String mRd =
                temp.substring(temp.indexOf('\$') + 1, temp.indexOf(','));
            temp = temp.substring(temp.indexOf(',') + 1, temp.length).trim();

            //rs
            String mRs =
                temp.substring(temp.indexOf('\$') + 1, temp.indexOf(','));
            temp = temp.substring(temp.indexOf(',') + 1, temp.length).trim();

            //rt
            String mRt = temp.substring(temp.indexOf('\$') + 1, temp.length);

            instruction.rd =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRd)), 5);
            //print(instruction.rd);

            instruction.rs =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRs)), 5);
            //print(instruction.rs);

            instruction.rt =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRt)), 5);
            //print(instruction.rt);

            break;
          }
        //mult
        case '011000':
          {
            //rd
            String mRd = fillBinaryString('', 5);

            //rs
            String mRs =
                temp.substring(temp.indexOf('\$') + 1, temp.indexOf(','));
            temp = temp.substring(temp.indexOf(',') + 1, temp.length).trim();

            //rt
            String mRt = temp.substring(temp.indexOf('\$') + 1, temp.length);

            instruction.rd = mRd;
            //print(instruction.rd);

            instruction.rs =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRs)), 5);
            //print(instruction.rs);

            instruction.rt =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRt)), 5);
            //print(instruction.rt);
            break;
          }

        default:
          {
            print('error 1');
          }
      }
    } else if (instruction.type == 'j') {
      switch (instruction.op_code) {
        case '000010':
          {
            instruction.target =
                temp.substring(temp.indexOf(' ') + 1, temp.length);
            //print(instruction.jumpAddress);
            break;
          }
        default:
          {
            print('error 2');
          }
      }
    } else if (instruction.type == 'i') {
      switch (instruction.op_code) {
        //beq
        case '000100':
        //bne
        case '000101':
          {
            //rs
            String mRs =
                temp.substring(temp.indexOf('\$') + 1, temp.indexOf(','));
            temp = temp.substring(temp.indexOf(',') + 1, temp.length).trim();

            //rs
            String mRt =
                temp.substring(temp.indexOf('\$') + 1, temp.indexOf(','));
            temp = temp.substring(temp.indexOf(',') + 1, temp.length).trim();

            //jump
            String mJumpAddress =
                temp.substring(temp.indexOf(',') + 1, temp.length);

            instruction.rs =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRs)), 5);
            //print(instruction.rs);

            instruction.rt =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRt)), 5);
            //print(instruction.rt);

            instruction.target = mJumpAddress;
            //print(instruction.jumpAddress);

            break;
          }
        //bgtz
        case '000111':
        //blez
        case '000110':
          {
            //rs
            String mRs =
                temp.substring(temp.indexOf('\$') + 1, temp.indexOf(','));
            temp = temp.substring(temp.indexOf(',') + 1, temp.length).trim();

            //jump
            String mJumpAddress =
                temp.substring(temp.indexOf(',') + 1, temp.length);

            instruction.rs =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRs)), 5);

            instruction.rt = "00000";
            //print(instruction.rs);

            instruction.target = mJumpAddress;
            //print(instruction.jumpAddress);

            break;
          }
        //addi
        case '001000':
          {
            //rd
            String mRs =
                temp.substring(temp.indexOf('\$') + 1, temp.indexOf(','));
            temp = temp.substring(temp.indexOf(',') + 1, temp.length).trim();

            //rs
            String mRt =
                temp.substring(temp.indexOf('\$') + 1, temp.indexOf(','));
            temp = temp.substring(temp.indexOf(',') + 1, temp.length).trim();

            //value
            String mValue = decimalToBinary(int.parse(temp));

            instruction.rs =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRs)), 5);
            print(instruction.rs);

            instruction.rt =
                fillBinaryString(decimalToBinary(getRegisterSerial(mRt)), 5);
            print(instruction.rt);

            instruction.target = fillBinaryString(mValue, 16);

            instruction.isTargetAValue = true;
            //print(instruction.value);

            break;
          }
        default:
          {
            print('error 3');
          }
      }
    } else {
      //error
    }

    return instruction;
  }
}

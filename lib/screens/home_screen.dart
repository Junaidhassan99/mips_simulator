import 'package:flutter/material.dart';
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
    Map<String, String?> result =
        TranslationUtilities.translateToGetFunctAndOpMachineCode('add');

    //print("${result['op']} ; ${result['fn']}");

    //print(TranslationUtilities.binaryToDecimal('11011110'));

    //print(x.length);
    //x.forEach((element) => print(element));

    //print(TranslationUtilities.getRegisterName(13));
    //print(TranslationUtilities.getRegisterSerial('t2'));

    String exampleInstructionR = 'add \$t1, \$s3, \$s3';
    String exampleInstructionI = 'bne \$t0, \$s5, Exit';
    String exampleInstructionJ = 'j Loop';
    //print(exampleInstructionR);
    //
    return Scaffold(
      body: Center(
        child: Text('working'),
      ),
    );
  }
}

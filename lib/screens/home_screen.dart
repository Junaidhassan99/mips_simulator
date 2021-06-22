import 'package:flutter/material.dart';
import 'package:mips_simulator/models/instruction.dart';
import 'package:mips_simulator/utilities/translation_utilties.dart';
import 'package:mips_simulator/widgets/disp_instruction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Create an integer list of length 31 will be used as registers
  List<int> x = List.filled(31, 0);

  List<Instruction> instructionList = [];

  TextEditingController _textEditorController = TextEditingController();

  //String testText='';

  Widget _titleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _editAndOutputParentWidget(String title, Widget child) {
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width * 0.45,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _titleText(title),
              child,
            ],
          ),
        ),
      ),
    );
  }

  void _runSimulation() {
    instructionList = [];
    setState(() {
      _textEditorController.text.split('\n').forEach((line) {
        line = line.trim();
        if (line.isNotEmpty) {
          Instruction instruction = TranslationUtilities.decoder(line);
          instructionList.add(instruction);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //testing

    // String exampleInstructionR = 'addi \$t1, \$s3, 16';
    // String exampleInstructionI1 = 'bne \$t0, \$s5, Exit';
    // String exampleInstructionI2 = 'bgtz \$t9, Exit';
    // String exampleInstructionJ = 'j Loop';

    // Instruction instruction =
    //     TranslationUtilities.decoder('add \$t1, \$s3, \$s3');

    // print(instruction.funct);
    // print(instruction.instructionAddress);
    // print(instruction.jumpAddress);
    // print(instruction.op_code);
    // print(instruction.rd);
    // print(instruction.rs);
    // print(instruction.rt);
    // print(instruction.shift);
    // print(instruction.type);
    // print(instruction.value);

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Input Editor
                    _editAndOutputParentWidget(
                      'Text Editor',
                      TextField(
                        controller: _textEditorController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    //System Tray
                    Container(
                      height: 500,
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _runSimulation,
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.green,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Output Screen
                    _editAndOutputParentWidget(
                      'Output',
                      Expanded(
                        child: ListView.builder(
                          itemCount: instructionList.length,
                          itemBuilder: (_, index) => DispInstruction(
                            instructionList[index],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //Register Bar
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Card(
                    //color: Colors.red,
                    child: Column(
                      children: [
                        _titleText('Register Data'),
                        Expanded(
                          //height: 150,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: x.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text(
                                        '$index',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        '${x[index]}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

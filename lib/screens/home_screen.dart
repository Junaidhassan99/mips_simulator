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
  int _lineNumberUnderExecutuion = 0;

  List<Instruction> instructionList = [];
  List<Branch> branchList = [];

  TextEditingController _textEditorController = TextEditingController();
  FocusNode _textEditorFocusNode = FocusNode();

  //String testText='';

  Widget _titleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    _lineNumberUnderExecutuion = 0;

    List<String> inputStringList = _textEditorController.text.split('\n');
    List<String> addressList =
        TranslationUtilities.getHexAddressesOfLength(inputStringList.length);

    instructionList = [];
    branchList = [];
    x = List.filled(31, 0);

    setState(
      () {
        for (int i = 0; i < inputStringList.length; i++) {
          String line = inputStringList[i];
          line = line.trim();

          if (line.contains(':')) {
            branchList.add(
              Branch(addressList[i], line.replaceAll(':', '')),
            );
          }
        }

        for (int i = 0; i < inputStringList.length; i++) {
          _lineNumberUnderExecutuion++;

          String line = inputStringList[i];
          line = line.trim();

          if (line.isNotEmpty && !line.contains(':')) {
            Instruction instruction = TranslationUtilities.decoder(line);

            instruction.instructionAddress = addressList[i];

            Map<String, dynamic> executionResult =
                TranslationUtilities.execute(x, instruction);

            instruction.result = executionResult['res'];
            instruction.isJumpAllowed = executionResult['ija'];

            instructionList.add(instruction);

            //Target name is being translated to Target address (if exists)
            if (instruction.target != null) {
              if (branchList
                  .map((e) => e.branchName)
                  .contains(instruction.target)) {
                instruction.target = branchList
                    .firstWhere(
                        (element) => element.branchName == instruction.target)
                    .instructionAddress;
              }
            }

            if (instruction.target != null &&
                !instruction.isTargetAValue &&
                instruction.isJumpAllowed &&
                branchList
                    .map((e) => e.instructionAddress)
                    .contains(instruction.target)) {
              int jumpToIndex = addressList.indexOf(instruction.target!);
              i = jumpToIndex;
              continue;
            }
          } else {
            print('Non-Executable line');
          }
        }
      },
    );
  }

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Occured!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('A syntaxt error has occured in the code'),
                Text('At line number: $_lineNumberUnderExecutuion'),
                const Text('Make sure to check spacing and syntaxt'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _getISAInfoRow(
      String instruction, String opCodeOrFunctCode, String instructionType,
      [bool isTitle = false]) {
    final TextStyle titleTextStyle =
        TextStyle(fontWeight: isTitle ? FontWeight.bold : null);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              instruction.padLeft(4, ' '),
              style: titleTextStyle,
            ),
            Text(
              opCodeOrFunctCode,
              style: titleTextStyle,
            ),
            Text(
              instructionType,
              style: titleTextStyle,
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Future<void> _infoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Avalible ISA')),
          content: SingleChildScrollView(
            child: Container(
              width: 500,
              child: ListBody(
                children: <Widget>[
                  _getISAInfoRow(
                      'Instruction', 'OP/Funct', 'Instruction Type', true),
                  _getISAInfoRow('beq', '000100', 'I'),
                  _getISAInfoRow('bne', '000101', 'I'),
                  _getISAInfoRow('bgtz', '000111', 'I'),
                  _getISAInfoRow('blez', '000110', 'I'),
                  _getISAInfoRow('addi', '001000', 'I'),
                  _getISAInfoRow('j', '000010', 'J'),
                  _getISAInfoRow('add', '100000', 'R'),
                  _getISAInfoRow('sub', '100010', 'R'),
                  _getISAInfoRow('mult', '011000', 'R'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //testing

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
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
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Input Editor
                      GestureDetector(
                        onTap: () => _textEditorFocusNode.requestFocus(),
                        child: _editAndOutputParentWidget(
                          'Text Editor',
                          Expanded(
                            child: SingleChildScrollView(
                              child: TextField(
                                focusNode: _textEditorFocusNode,
                                controller: _textEditorController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //System Tray
                      Container(
                        height: 500,
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  try {
                                    _runSimulation();
                                  } catch (error) {
                                    await _showErrorDialog();
                                  }
                                },
                                icon: const Icon(
                                  Icons.play_circle_outlined,
                                  color: Colors.green,
                                  size: 35,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _infoDialog();
                                },
                                icon: const Icon(
                                  Icons.info,
                                  color: Colors.grey,
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
                                        '\$$index',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '\$${TranslationUtilities.getRegisterName(index)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(
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
                              },
                            ),
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
      ),
    );
  }
}

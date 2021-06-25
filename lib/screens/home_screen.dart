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

    String currentHexAddress = '00400000';

    instructionList = [];
    branchList = [];
    x = List.filled(31, 0);

    setState(() {
      _textEditorController.text.split('\n').forEach((line) {
        _lineNumberUnderExecutuion++;

        line = line.trim();

        if (line.contains(':')) {
          branchList.add(
            Branch(currentHexAddress, line.replaceAll(':', '')),
          );
        } else if (line.isNotEmpty) {
          Instruction instruction = TranslationUtilities.decoder(line);

          instruction.instructionAddress = currentHexAddress;

          instruction.result =
              TranslationUtilities.executeAccordingToType(x, instruction);

          instructionList.add(instruction);
        } else {
          //error
        }

        currentHexAddress =
            TranslationUtilities.incrementHexAddress(currentHexAddress);
      });

      instructionList.forEach((instruction) {
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
      });
    });
  }

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
              child: const Text('Cancel'),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
    );
  }
}

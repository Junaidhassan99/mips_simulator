import 'package:flutter/material.dart';
import 'package:mips_simulator/screens/home_screen.dart';

void main() {
  runApp(MipsSimulator());
}

class MipsSimulator extends StatelessWidget {
  const MipsSimulator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulator for MIPS',
      home: HomeScreen(),
    );
  }
}

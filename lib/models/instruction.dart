class Instruction {
  //6-bit
  String op_code;
  String type;
  //Depends on memory size
  String instructionAddress;
  bool isTargetAValue;
  //5-bit
  String? rs;
  //5-bit
  String? rt;
  //5-bit
  String? rd;
  //5-bit
  String? shift;
  //6-bit
  String? funct;
  //unknown-bit
  String? target;
  String? result;

  Instruction({
    required this.type,
    required this.op_code,
    required this.instructionAddress,
    this.isTargetAValue=false,
    this.result,
    this.funct,
    this.target,
    this.rd,
    this.rs,
    this.rt,
    this.shift,

    //this.value,
  });
}

class Branch {
  String instructionAddress;
  String branchName;

  Branch(this.instructionAddress, this.branchName);
}

class Instruction {
  //6-bit
  String op_code;
  String type;
  //Depends on memory size
  String instructionAddress;
  //In binary form
  String? value;
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
  String? jumpAddress;

  Instruction({
    required this.type,
    required this.op_code,
    required this.instructionAddress,
    this.funct,
    this.jumpAddress,
    this.rd,
    this.rs,
    this.rt,
    this.shift,
    this.value,
  });
}

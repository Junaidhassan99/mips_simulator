class Instruction {
  //6-bit
  String op_code;
  String type;
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
    this.funct,
    this.jumpAddress,
    this.rd,
    this.rs,
    this.rt,
    this.shift,
  });
}

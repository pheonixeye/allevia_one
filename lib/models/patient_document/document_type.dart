enum DocumentType {
  lab_res,
  rad_res,
  presc;

  factory DocumentType.fromString(String value) {
    return values.firstWhere((e) => e.name == value);
  }
}

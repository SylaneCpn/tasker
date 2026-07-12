extension CapitalizeString on String {
  String capitalize() {
  final [firstLetter, ...rest] = split("");
    return [firstLetter.toUpperCase() , ...rest].join("");
  }
}

const garranteedLeapYear = 400;

bool isLeapYear(int year)  {
  final c1 = year % 4 == 0 && year % 100 != 0;
  final c2 = year % 400 == 0;
  return c1 || c2;

}
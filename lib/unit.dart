abstract class Unit {
  String name;
  int hp;

  Unit({required this.name, required this.hp});

  void attack(Unit target);
  void showStatus();
}

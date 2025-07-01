import 'unit.dart';
import 'character.dart';

class Monster extends Unit {
  int attackPower;
  final int defensePower = 0;

  Monster({
    required String super.name,
    required int super.hp,
    required this.attackPower,
  });

  @override
  void attack(Unit target) {
    if (target is Character) {
      int damage = attackPower - target.defensePower;
      if (damage < 0) damage = 0;
      target.hp -= damage;
      print('$name이(가) ${target.name}에게 $damage의 피해를 입혔습니다!');
    }
  }

  @override
  void showStatus() {
    print('===== $name 상태 =====');
    print('체력: $hp');
    print('공격력: $attackPower');
    print('=====================');
  }
}

import 'unit.dart';
import 'character.dart';

class Monster extends Unit {
  int attackPower;
  int defensePower = 0;
  int turnCount = 0; // 턴 카운터 (방어력 증가용)

  Monster({required super.name, required super.hp, required this.attackPower});

  @override
  void attack(Unit target) {
    if (target is Character) {
      int damage = attackPower - target.defensePower;
      if (damage < 0) damage = 0;
      target.hp -= damage;
      print('$name이(가) ${target.name}에게 $damage의 피해를 입혔습니다!');
    }
  }

  // 방어력 증가 함수
  void increaseDefenseIfNeeded() {
    turnCount++;
    if (turnCount >= 3) {
      defensePower += 2;
      turnCount = 0;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defensePower');
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

import 'unit.dart';
import 'monster.dart';

class Character extends Unit {
  int attackPower;
  int defensePower;
  bool usedItem = false;

  Character({
    required super.name,
    required super.hp,
    required this.attackPower,
    required this.defensePower,
  });

  //아이템 사용 함수
  void useItem() {
    if (!usedItem) {
      attackPower *= 2;
      usedItem = true;
      print('$name이(가) 아이템을 사용하여 공격력이 두 배가 되었습니다!');
    } else {
      print('⚠️ 이미 아이템을 사용하셨습니다.');
    }
  }

  @override
  void attack(Unit target) {
    if (target is Monster) {
      int damage = attackPower - target.defensePower;
      if (damage < 0) damage = 0;
      target.hp -= damage;
      print('$name이(가) ${target.name}에게 $damage의 피해를 입혔습니다!');
    }
  }

  void defend(int damageFromMonster) {
    hp += damageFromMonster;
    print('$name이(가) 방어하여 체력이 $damageFromMonster만큼 회복되었습니다!');
  }

  @override
  void showStatus() {
    print('===== $name 상태 =====');
    print('체력: $hp');
    print('공격력: $attackPower');
    print('방어력: $defensePower');
    print('=====================');
  }
}

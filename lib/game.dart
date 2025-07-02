import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

//게임을 진행하는 클래스
class Game {
  late Character character;
  List<Monster> monsters = [];

  //캐릭터 데이터 로드
  Future<void> loadCharacter(String filePath) async {
    try {
      final file = File(filePath);
      final lines = await file.readAsLines();

      final stats = lines[0].split(',');

      int hp = int.parse(stats[0]);
      int atk = int.parse(stats[1]);
      int def = int.parse(stats[2]);

      String input = '';
      while (true) {
        stdout.write('캐릭터 이름을 입력하세요: ');
        input = stdin.readLineSync() ?? '';

        if (input.trim().isEmpty ||
            !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
          print('❌ 잘못된 이름 형식입니다. 다시 입력해주세요.');
        } else {
          break;
        }
      }

      character = Character(
        name: input,
        hp: hp,
        attackPower: atk,
        defensePower: def,
      );
    } catch (e) {
      print('❌ 캐릭터 불러오기 실패: $e');
      return;
    }
  }

  //몬스터 데이터 로드
  Future<void> loadMonsters(String filePath) async {
    try {
      final file = File(filePath);
      final lines = await file.readAsLines();

      for (final line in lines) {
        final stats = line.split(',');
        if (stats.length != 3) continue;

        String name = stats[0];
        int hp = int.parse(stats[1]);
        int maxAtk = int.parse(stats[2]);
        int randomAtk = max(
          Random().nextInt(maxAtk + 1),
          character.defensePower,
        );

        monsters.add(Monster(name: name, hp: hp, attackPower: randomAtk));
      }
    } catch (e) {
      print('몬스터 불러오기 실패: $e');
      return;
    }
  }

  //전투 시작
  void battleStart() {
    while (monsters.isNotEmpty && character.hp > 0) {
      // 1. 랜덤으로 몬스터 선택
      final getRandomMonster = Random().nextInt(monsters.length);
      final monster = monsters[getRandomMonster];

      print('\n${monster.name}이(가) 나타났다!');

      // 2. 전투 루프
      while (monster.hp > 0 && character.hp > 0) {
        character.showStatus();
        monster.showStatus();

        stdout.write('공격(1) / 방어(2): ');
        String? choice = stdin.readLineSync();

        if (choice == '1') {
          character.attack(monster);
        } else if (choice == '2') {
          character.defend(monster.attackPower);
        } else {
          print('잘못된 선택입니다.');
          continue;
        }

        if (monster.hp > 0) {
          monster.attack(character);
        }
      }

      // 3. 체력 체크
      if (character.hp <= 0) {
        print('\n${character.name}이(가) 쓰러졌습니다... 게임 오버.');
        return;
      }

      // 4. 처치한 몬스터 제거
      if (monster.hp <= 0) {
        print('${monster.name}을(를) 처치했습니다!');
        monsters.remove(monster);
      }

      // 5. 다음 몬스터와 싸울지 선택
      if (monsters.isNotEmpty) {
        stdout.write('다음 몬스터와 싸우시겠습니까? (y/n): ');
        String? next = stdin.readLineSync();
        if (next?.toLowerCase() != 'y') break;
      }
    }

    print('\n모든 전투가 종료되었습니다.');
  }

  //결과 저장
  void saveResult() {
    stdout.write('\n결과를 저장하시겠습니까? (y/n): ');
    String? input = stdin.readLineSync();

    if (input?.toLowerCase() == 'y') {
      final result =
          '이름: ${character.name}, 남은 체력: ${character.hp}, 결과: ${character.hp > 0 ? '승리' : '패배'}';
      File('result.txt').writeAsStringSync(result);
      print('결과가 result.txt에 저장되었습니다.');
    } else {
      print('결과 저장을 취소했습니다.');
    }
  }
}

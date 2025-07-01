import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

class Game {
  late Character character;
  List<Monster> monsters = [];

  Future<void> loadCharacter(String filePath) async {
    try {
      final file = File(filePath);
      final lines = await file.readAsLines();

      if (lines.isEmpty) throw FormatException('캐릭터 데이터가 비어 있음');

      final stats = lines[0].split(',');
      if (stats.length != 3) throw FormatException('캐릭터 데이터 형식 오류');

      int hp = int.parse(stats[0]);
      int atk = int.parse(stats[1]);
      int def = int.parse(stats[2]);

      stdout.write('캐릭터 이름을 입력하세요: ');
      String? input = stdin.readLineSync();
      if (input == null ||
          input.trim().isEmpty ||
          !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
        throw FormatException('잘못된 이름 형식');
      }

      character = Character(
        name: input,
        hp: hp,
        attackPower: atk,
        defensePower: def,
      );
    } catch (e) {
      print('캐릭터 불러오기 실패: $e');
      exit(1);
    }
  }

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
      exit(1);
    }
  }

  void startBattle() {
    for (final monster in monsters) {
      print('\n${monster.name}이(가) 나타났다!');

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

      if (character.hp <= 0) {
        print('\n${character.name}이(가) 쓰러졌습니다... 게임 오버.');
        return;
      }

      stdout.write('다음 몬스터와 싸우시겠습니까? (y/n): ');
      String? next = stdin.readLineSync();
      if (next?.toLowerCase() != 'y') break;
    }

    print('\n모든 전투가 종료되었습니다.');
  }

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

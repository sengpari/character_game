//import 'dart:io';
import '../lib/game.dart';

void main() async {
  final game = Game();

  // 캐릭터 로드
  await game.loadCharacter('characters.txt');

  // 몬스터들 로드
  await game.loadMonsters('monsters.txt');

  // 게임 시작
  print('\n⚔️ 게임이 시작됩니다 ⚔️\n');
  game.startBattle();

  // 결과 저장 여부 확인
  game.saveResult();
}

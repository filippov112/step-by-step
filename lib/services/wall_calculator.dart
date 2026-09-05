
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/enums/wall_status.dart';

class WallCalculator {

  // Множитель за разрушение стены
  static const _successMulti = 2;

  // Награды за успех от сложности
  static const _diffSuccessMap = <WallDiff,int>{
    WallDiff.F: 50,
    WallDiff.E: 75,
    WallDiff.D: 120,
    WallDiff.C: 250,
    WallDiff.B: 500,
    WallDiff.A: 1000,
    WallDiff.S: 3000,
    WallDiff.SS: 6000,
    WallDiff.SSS: 9000,
    WallDiff.EX: 25000,
  };

  // Награды за провал от сложности
  static const _diffFailureMap = <WallDiff,int>{
    WallDiff.F: 10,
    WallDiff.E: 15,
    WallDiff.D: 25,
    WallDiff.C: 40,
    WallDiff.B: 70,
    WallDiff.A: 100,
    WallDiff.S: 300,
    WallDiff.SS: 600,
    WallDiff.SSS: 900,
    WallDiff.EX: 1500,
  };

  // Награды за провал от сложности
  static const _attemptPriceMap = <WallDiff,int>{
    WallDiff.F: 6,
    WallDiff.E: 9,
    WallDiff.D: 15,
    WallDiff.C: 24,
    WallDiff.B: 42,
    WallDiff.A: 60,
    WallDiff.S: 180,
    WallDiff.SS: 300,
    WallDiff.SSS: 300,
    WallDiff.EX: 450,
  };

  static int getSuccesPrice(WallDiff diff, int attempts, WallStatus status) {
    int multi = status == WallStatus.destroyed ? _successMulti : 1;
    return ((_diffSuccessMap[diff] ?? 0) + (_attemptPriceMap[diff] ?? 0) * attempts) * multi;
  }

  static int getFailurePrice(WallDiff diff, int attempts, WallStatus status) {
    int multi = status == WallStatus.destroyed ? _successMulti : 1;
    return ((_diffFailureMap[diff] ?? 0) + (_attemptPriceMap[diff] ?? 0) * attempts) * multi;
  }
}
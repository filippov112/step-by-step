
import 'package:chaos_control/models/enums/target_difficulty.dart';
import 'package:chaos_control/models/enums/target_status.dart';

class TargetCalculator {

  // Множитель за разрушение стены
  static const _successMulti = 2;

  // Награды за успех от сложности
  static const _diffSuccessMap = <TargetDiff,int>{
    TargetDiff.F: 50,
    TargetDiff.E: 75,
    TargetDiff.D: 120,
    TargetDiff.C: 250,
    TargetDiff.B: 500,
    TargetDiff.A: 1000,
    TargetDiff.S: 3000,
    TargetDiff.SS: 6000,
    TargetDiff.SSS: 9000,
    TargetDiff.EX: 25000,
  };

  // Награды за провал от сложности
  static const _diffFailureMap = <TargetDiff,int>{
    TargetDiff.F: 10,
    TargetDiff.E: 15,
    TargetDiff.D: 25,
    TargetDiff.C: 40,
    TargetDiff.B: 70,
    TargetDiff.A: 100,
    TargetDiff.S: 300,
    TargetDiff.SS: 600,
    TargetDiff.SSS: 900,
    TargetDiff.EX: 1500,
  };

  // Награды за провал от сложности
  static const _taskPriceMap = <TargetDiff,int>{
    TargetDiff.F: 6,
    TargetDiff.E: 9,
    TargetDiff.D: 15,
    TargetDiff.C: 24,
    TargetDiff.B: 42,
    TargetDiff.A: 60,
    TargetDiff.S: 180,
    TargetDiff.SS: 300,
    TargetDiff.SSS: 300,
    TargetDiff.EX: 450,
  };

  static int getSuccesPrice(TargetDiff diff, int tasks, TargetStatus status) {
    int multi = status == TargetStatus.destroyed ? _successMulti : 1;
    return ((_diffSuccessMap[diff] ?? 0) + (_taskPriceMap[diff] ?? 0) * tasks) * multi;
  }

  static int getFailurePrice(TargetDiff diff, int tasks, TargetStatus status) {
    int multi = status == TargetStatus.destroyed ? _successMulti : 1;
    return ((_diffFailureMap[diff] ?? 0) + (_taskPriceMap[diff] ?? 0) * tasks) * multi;
  }
}
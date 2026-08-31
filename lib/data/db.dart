import 'dart:io';
import 'package:chaos_control/models/achievement.dart';
import 'package:chaos_control/models/achievement_bonus.dart';
import 'package:chaos_control/models/characteristic.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/models/class_hierarchy.dart';
import 'package:chaos_control/models/class_skill.dart';
import 'package:chaos_control/models/script_task.dart';
import 'package:chaos_control/models/skill_rang_bonus.dart';
import 'package:chaos_control/models/tag_achievement.dart';
import 'package:chaos_control/models/tag_class.dart';
import 'package:chaos_control/models/tag_skill.dart';
import 'package:chaos_control/models/tag_task.dart';
import 'package:chaos_control/models/task_reward.dart';
import 'package:chaos_control/models/script.dart';
import 'package:chaos_control/models/skill.dart';
import 'package:chaos_control/models/skill_condition.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/task_hierarchy.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



class DB {
  static Database? db;

  static Future<void> dropDb() async {
    await deleteDatabase(await _getDBPath());
  }

  static Future initDb() async {
    sqfliteFfiInit();
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      databaseFactory = databaseFactoryFfi;
    }

    db = await openDatabase(await _getDBPath(), version: 1,
      onCreate: (Database db, int version) async {

      await db.execute('PRAGMA foreign_keys = ON;');
      await db.execute(Class.init);
      await db.execute(Profile.init);
      await db.execute(Task.init);
      await db.execute(Skill.init);
      await db.execute(Achievement.init);
      await db.execute(Tag.init);
      await db.execute(Script.init);
      await db.execute(TagClass.init);
      await db.execute(Characteristic.init); // зависит от Class
      await db.execute(ClassHierarchy.init); // зависит от Class
      await db.execute(TaskHierarchy.init); // зависит от Task
      await db.execute(AchievementBonus.init); // зависит от Achievement
      await db.execute(ClassSkill.init); // зависит от Skill, Class
      await db.execute(SkillRangBonus.init); // зависит от Skill, Characteristic
      await db.execute(TaskReward.init);        // зависит от Task, Skill
      await db.execute(ScriptTask.init);    // зависит от Script, Task
      await db.execute(SkillCondition.init); // зависит от Skill
      await db.execute(TagSkill.init);      // зависит от Tag, Skill
      await db.execute(TagAchievement.init); // зависит от Tag, Achievement
      await db.execute(TagTask.init);       // зависит от Tag, Task
    });
  }

  // =======

  static Future<String> _getDBPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    return path;
  }
}


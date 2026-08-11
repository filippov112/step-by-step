import 'dart:io';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/script_task.dart';
import 'package:life_game/models/tag_achievement.dart';
import 'package:life_game/models/tag_skill.dart';
import 'package:life_game/models/tag_task.dart';
import 'package:life_game/models/task_reward.dart';
import 'package:life_game/models/script.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/models/task_hierarchy.dart';
import 'package:life_game/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class DB {
  static Database? db;

  static Future<void> dropDb() async {
    // Delete the database
    await deleteDatabase(await _getDBPath());
  }

  static Future initDb() async {
    if (db != null) {
      return;
    }
    // Init ffi loader if needed.
    sqfliteFfiInit();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      databaseFactory = databaseFactoryFfi;
    }
    // Connection
    db = await openDatabase(await _getDBPath(), version: 1,
      onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute('PRAGMA foreign_keys = ON;');

      await db.execute(User.init);
      await db.execute(Task.init);
      await db.execute(TaskHierarchy.init);
      await db.execute(Skill.init);
      await db.execute(Achievement.init);
      await db.execute(Tag.init);
      await db.execute(Script.init);
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
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    return path;
  }
}


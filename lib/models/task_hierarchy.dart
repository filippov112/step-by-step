class TaskHierarchy {
  static const tnThis = "taskschild";
  static const tnTasks = "tasks";
  
  static const cId = "_id";
  static const cParent = "_parent";
  static const cChild = "_child";

  static const init = '''
        CREATE TABLE $tnThis (
          $cChild TEXT NOT NULL,
          $cParent TEXT NOT NULL,
          PRIMARY KEY ($cParent, $cChild)
          FOREIGN KEY ($cChild) REFERENCES $tnTasks($cId) ON DELETE CASCADE
          FOREIGN KEY ($cParent) REFERENCES $tnTasks($cId) ON DELETE CASCADE
        );
        ''';
}
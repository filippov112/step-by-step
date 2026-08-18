import 'package:flutter/material.dart';

abstract class ListModel<T> extends ChangeNotifier {

  final List<T> list = [];
  final List<T> selected = [];
  final List<T> searchingCache = [];
  
  // Режим выделения
  bool selectMode = false;
  // Выполнение долгой операции
  bool loadingState = false;

  
  // Загрузка данных
  Future load();
  
  Future update(T data);

  Future delete(String id);
  
  Future deleteSelected();
  
  // Переключить режим выделения
  void toggleSelectionMode() {
    selectMode = !selectMode;
    if (!selectMode) {
      selected.clear();
    }
    notifyListeners();
  }


  void toggleSelectingAll(bool val) {
    selected.clear();
    if (val) {
      list.map((t) { selected.add(t); });
    }
    notifyListeners();
  }
  
  // Выделить все
  void selectAll() {
    selected.clear();
    list.map((t) { selected.add(t); });
    notifyListeners();
  }
  
  // Выделить / снять выделение с объекта
  void toggleSelecting(T data) {
    if (selected.contains(data)) {
      selected.remove(data);
    } else {
      selected.add(data);
    }
    notifyListeners();
  }
}
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';

class CustomTreeListModel<T> {
  
  String currentAddress = '';
  TreeRecord<T>? currentFolder;

  List<TreeRecord<T>> openFolder({required List<TreeRecord<T>> list, TreeRecord<T>? folder, bool groupFilter = true}) {
    if (!groupFilter) {
      currentAddress = '';
      currentFolder = null;
      return list;
    }
    currentFolder = folder;
    if (folder != null) {
      currentAddress = folder.address.isEmpty ? '' : folder.address;
    } else {
      currentAddress = '';
    }
    return [?_backRecord(), ..._getFolders(list), ..._getChildRecords(list)];
  }

  TreeRecord<T>? _backRecord() {
    if (currentAddress.isEmpty) return null;
    final parents = currentAddress.split('/');

    return TreeRecord<T>(
      isFolder: true,
      address: parents.take(parents.length - 1).join('/'),
      name: '/..',
    );
  }

  // Дочерние записи
  List<TreeRecord<T>> _getChildRecords(List<TreeRecord<T>> list) {
    List<TreeRecord<T>> records = [];
    
    // Оставляем только записи текущего каталога
    List<TreeRecord<T>> filteredList = list.where((e) => e.address == currentAddress).toList();
    for (var record in filteredList) {
      records.add(record);
    }
    return records;
  }


  // Дочерние каталоги
  List<TreeRecord<T>> _getFolders(List<TreeRecord<T>> list) {
    Set<String> folderNames = {};

    void addFolder(String addr) {
      final parts = addr.split('/');
      if (parts[0].isNotEmpty) {
        folderNames.add(parts[0]);
      }
    }

    // отфильтровываем записи в других каталогах и отсекаем текущий каталог
    List<String> filteredList = [];
    
    if (currentAddress.isEmpty) {
      for(var rec in list) {
        filteredList.add(rec.address);
      }
    } else {
      for(var rec in list.where((e) => e.address.startsWith('$currentAddress/'))) {
        filteredList.add(rec.address.substring(currentAddress.length + 1));
      }
    }
    for (var addr in filteredList) {
      addFolder(addr);
    }

    List<TreeRecord<T>> results = [];
    for (var name in folderNames) {
      final path = (currentAddress.isEmpty ? [name,] : [currentAddress, name]).join('/');
      results.add(TreeRecord<T>(
        isFolder: true,
        name: name,
        address: path,
        children: list
            .where((e) => e.address.startsWith(path))
            .toList(),
      ));
    }
    return results;
  }
}

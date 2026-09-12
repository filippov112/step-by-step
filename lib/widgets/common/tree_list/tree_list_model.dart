import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';

class CustomTreeListModel<T> {
  
  String currentAddress = '';
  TreeRecord<T>? currentFolder;
  void resetAddress() {
    currentAddress = '';
    currentFolder = null;
  }

  List<TreeRecord<T>> openFolder({required List<TreeRecord<T>> list, TreeRecord<T>? folder, bool groupFilter = true}) {
    if (!groupFilter) {
      resetAddress();
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
    Map<String,CustomImageData?> images = {};

    void addFolder((CustomImageData?, String) rec) {
      final parts = rec.$2.split('/');
      if (parts[0].isNotEmpty && !folderNames.contains(parts[0])) {
        images[parts[0]] = rec.$1;
        folderNames.add(parts[0]);
      }
    }

    // отфильтровываем записи в других каталогах и отсекаем текущий каталог
    List<(CustomImageData?, String)> filteredList = [];
    
    if (currentAddress.isEmpty) {
      for(var rec in list) {
        filteredList.add((rec.customIconData, rec.address));
      }
    } else {
      for(var rec in list.where((e) => e.address.startsWith('$currentAddress/'))) {
        filteredList.add((rec.customIconData, rec.address.substring(currentAddress.length + 1)));
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
        customIconData: images[name],
        name: name,
        address: path,
        children: list
            .where((e) => e.address.startsWith('$path/') || e.address == path)
            .toList(),
      ));
    }
    return results;
  }

  Future moveAllTo({
    required Map<String,String> idAndGroups, 
    required String newAddress, 
    required bool isSaveStructure,
    required Future Function(String,String) updateCallback
  }) async {
    // Если адрес не изменился и структуру не требуется сбрасывать, то не трогаем
    if (newAddress == currentAddress && isSaveStructure) return;
    int currentAddressSkip = currentAddress.isEmpty ? 0 : currentAddress.split('/').length;
    for (var item in idAndGroups.entries) {
      // Если не нужно сохранять структуру, то перебрасываем как есть.
      if (!isSaveStructure) {
        await updateCallback(item.key, newAddress);
      } else {
        List<String> struct = item.value.isEmpty ? [] : item.value.split('/');
        // Если адрес той же длины, что текущий, то перебрасываем как есть.
        if (struct.length == currentAddressSkip) {
          await updateCallback(item.key, newAddress);
        }
        List<String> newAddressParts = [];
        // Пустой адрес не учитываем
        if (newAddress.isNotEmpty) {
          newAddressParts.add(newAddress);
        }
        // Пропускаем части текущего адреса
        for(var i = currentAddressSkip; i < struct.length; i++) {
          // Подгруппы докидываем в новый адрес
          newAddressParts.add(struct[i]);
        }
        await updateCallback(item.key, newAddressParts.join('/'));
      }
    }
  }
}

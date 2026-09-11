import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/dialogs/icons/icons_finder_service.dart';

class IconsFinderService {
  Future<IconData?> select(BuildContext context) async {
    IconData? res;
    await showModalBottomSheet<IconData?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: SearchableIconPicker(onIconSelected: (icon) => res = icon),
      ),
    );
    return res;
  }
}

class SearchableIconPicker extends StatefulWidget {
  final Function(IconData) onIconSelected;

  const SearchableIconPicker({super.key, required this.onIconSelected});

  @override
  SearchableIconPickerState createState() => SearchableIconPickerState();
}

class SearchableIconPickerState extends State<SearchableIconPicker> {
  String searchQuery = '';
  List<NamedIcon> filteredIcons = [];

  final List<NamedIcon> allIcons = getAllMaterialIcons();

  @override
  void initState() {
    super.initState();
    filteredIcons = allIcons;
  }

  void filterIcons(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredIcons = allIcons;
      } else {
        // Простая фильтрация по имени
        filteredIcons = allIcons.where((icon) {
          // Ищем иконку по имени
          return icon.matchesSearch(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Поле поиска
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: filterIcons,
          ),
        ),
        // Сетка иконок
        
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: EdgeInsets.all(8),
            itemCount: filteredIcons.length,
            itemBuilder: (context, index) {
              final icon = filteredIcons[index];
              return GestureDetector(
                onTap: () {
                  widget.onIconSelected(icon.icon);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon.icon, size: 32),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Получить все иконки через рефлексию
  static List<NamedIcon> getAllMaterialIcons() {
    
    return GameficationIcons.allIcons;
  }
}
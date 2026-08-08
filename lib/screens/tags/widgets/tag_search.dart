import 'package:flutter/material.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:provider/provider.dart';

class TagSearch extends StatelessWidget {
  const TagSearch({
    super.key,
    required this.searchController
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {

    var searchQueryisNotEmpty = context.select<TagListModel,bool>((model) => model.searchQueryisNotEmpty);
    var updateSearch = context.read<TagListModel>().updateSearch;

    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Поиск тегов...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQueryisNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  updateSearch('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        // fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onChanged: updateSearch,
    );
     
    
  }
  
}
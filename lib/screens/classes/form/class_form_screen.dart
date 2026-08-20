import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/form/widgets/buttons.dart';
import 'package:life_game/screens/achievements/form/widgets/description.dart';
import 'package:life_game/screens/achievements/form/widgets/icon.dart';
import 'package:life_game/screens/achievements/form/widgets/tags.dart';
import 'package:life_game/screens/achievements/form/widgets/title.dart';
import 'package:life_game/screens/classes/form/class_form_model.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/entity_appbar.dart';
import 'package:provider/provider.dart';


class ClassFormScreen extends StatefulWidget {
  final Class? record;
  
  const ClassFormScreen({super.key, this.record});

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late ClassFormModel model;
  
  @override
  void initState() {
    super.initState();
    model = context.read<ClassFormModel>();
    model.setClass(widget.record);
  }

  @override
  Widget build(BuildContext context) {

    var isEditing = context.select<ClassFormModel,bool>((model) => model.isEditing);
    var selectedDescription = context.select<ClassFormModel,String>((model) => model.selectedDescription);
    var selectedTitle = context.select<ClassFormModel,String>((model) => model.selectedTitle);
    var selectedIcon = context.select<ClassFormModel,String?>((model) => model.selectedIcon);
    var selectedTags = context.select<ClassFormModel,List<Tag>>((model) => model.selectedTags);
    
    var setTitle = model.setTitle;
    var setIcon = model.setIcon;
    var setDescription = model.setDescription;
    var setSelectedTags = model.setSelectedTags;
    
    var save = model.save;
    var delete = model.delete;

    return Scaffold(
      appBar: buildAppBar(
        'Класс',
        deleteCallback: () => _delete(delete),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: 
              ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  // Иконка
                  CustomIconPicker(
                    currentIcon: selectedIcon,
                    setIcon: setIcon
                  ),
                  
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  Text(
                    'Основные поля',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12,),

                  // Название
                  buildTitleInput(selectedTitle: selectedTitle, setTitle: setTitle),
                  const SizedBox(height: 12),

                  // Описание
                  buildDescriptionInput(selectedDescription: selectedDescription, setDescription: setDescription),
                  const SizedBox(height: 12), 
                  
                  // Теги
                  buildTagsSection(
                    context, 
                    selectedTags: selectedTags, 
                    setSelectedTags: setSelectedTags
                  ),
                  
                  const SizedBox(height: 8),
                  

                ]
              ),   
            ),
            // Кнопки
            buildButtonsBlock(
              context, 
              saveCallback: () => _save(save), 
              isEditing: isEditing
            )
          ]
        ),
      ),
    );
  }

  Future _save(Future<bool> Function() save) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();
    var result = await save(); 
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  Future _delete(Future Function() delete) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await delete();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
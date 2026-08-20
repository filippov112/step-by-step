import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/class_skill.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/form/widgets/buttons.dart';
import 'package:life_game/screens/achievements/form/widgets/description.dart';
import 'package:life_game/screens/achievements/form/widgets/icon.dart';
import 'package:life_game/screens/achievements/form/widgets/tags.dart';
import 'package:life_game/screens/achievements/form/widgets/title.dart';
import 'package:life_game/screens/classes/form/class_form_model.dart';
import 'package:life_game/screens/classes/form/widgets/skills.dart';
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
  TextEditingController? titleController;
  TextEditingController? descController;
  
  @override
  void dispose() {
    titleController?.dispose();
    descController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model = context.read<ClassFormModel>();
    model.setClass(widget.record);
    var selectedDescription = model.selectedDescription;
    var selectedTitle = model.selectedTitle;
    titleController = TextEditingController(text: selectedTitle);
    descController = TextEditingController(text: selectedDescription);
  }

  @override
  Widget build(BuildContext context) {

    var isEditing = context.select<ClassFormModel,bool>((model) => model.isEditing);
    var selectedIcon = context.select<ClassFormModel,String?>((model) => model.selectedIcon);
    var selectedTags = context.select<ClassFormModel,List<Tag>>((model) => model.selectedTags);
    
    var setIcon = model.setIcon;
    var setSelectedTags = model.setSelectedTags;
    
    var save = model.save;
    var delete = model.delete;

    var classId = context.select<ClassFormModel,String>((model) => model.record.id);
    var skills = context.select<ClassFormModel,List<Skill>>((model) => model.allSkills);
    var selectedSkills = context.select<ClassFormModel,List<ClassSkill>>((model) => model.selectedClassSkills);
    var setSelectedSkills = model.setSelectedClassSkills;

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
                  buildTitleInput(controller: titleController,),
                  const SizedBox(height: 12),

                  // Описание
                  buildDescriptionInput(controller: descController),
                  const SizedBox(height: 12), 
                  
                  // Теги
                  buildTagsSection(
                    context, 
                    selectedTags: selectedTags, 
                    setSelectedTags: setSelectedTags
                  ),
                  
                  const SizedBox(height: 8),

                  // Награды
                  SkillsSection(
                    selectedSkills: selectedSkills, 
                    setSelectedSkills: setSelectedSkills, 
                    skills: skills, 
                    classId: classId
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

    model.setTitle(titleController?.text ?? '');
    model.setDescription(descController?.text ?? '');
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
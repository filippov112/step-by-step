import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/models/enums/purport_type.dart';
import 'package:chaos_control/screens/purports/list/purport_list_model.dart';
import 'package:chaos_control/screens/purports/detail/purport_details_model.dart';
import 'package:chaos_control/screens/purports/detail/purport_details_screen.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:provider/provider.dart';

class PurportListTile extends StatelessWidget {

  final PurportListModel model;
  final Purport purport;

  const PurportListTile({
    super.key, 
    required this.model, 
    required this.purport,
  });

  @override
  Widget build(BuildContext context) {

    final isSelected = model.selectedIds.contains(purport.id);
    Color? containterColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: purport.date == null ? 0.2 : 0.9);
    Gradient containterBorderColor = LinearGradient(
      transform: GradientRotation(0.7),
      colors: [purport.type.color.withValues(alpha: 0.5), containterColor],
      stops: [0, 0.2]);
    Color titleColor = Theme.of(context).colorScheme.onPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: containterBorderColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          onTap: () {
            if (model.isSelectionMode) {
              model.toggleSelectPurport(purport.id);
            } else {
              _openDetails(context, model, purport);
            }
          },
          onLongPress: () {
            if (!model.isSelectionMode) {
              model.toggleSelectionMode();
              model.toggleSelectPurport(purport.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                // Чекбокс для выделения или статуса
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 12),
                  child: model.isSelectionMode ? Checkbox(
                      value: isSelected,
                      onChanged: (_) => model.toggleSelectPurport(purport.id),
                    ) :
                    Padding(
                      padding: const EdgeInsetsGeometry.fromLTRB(12,12,0,12), 
                      child: CustomImageIcon(
                        purport.icon, 
                        altIcon: Icons.star_border, 
                        color: purport.type.color, 
                        width: 40, height: 40
                      ),
                    ),
                ),
                
                // Информация
                Expanded(
                  child: Text(
                    purport.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ),
                
                if (model.isSelectionMode) ...{
                  SizedBox(width: 8,),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    onPressed: () => _deletePurport(context, purport, model.deletePurport),
                    tooltip: 'Удалить',
                  ),
                }
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> _deletePurport(BuildContext context, Purport purport, Future Function(String) deletePurport) async {
    if (await showConfirmDialog(context) == true) {
      await deletePurport(purport.id);
    }
  }


  Future _openDetails(BuildContext context, PurportListModel model, Purport purport) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => PurportDetailsModel(), 
          child: PurportDetailScreen(purport: purport),
        ),
      ),
    );
    if (context.mounted) model.loadPurports(); 
  }
}
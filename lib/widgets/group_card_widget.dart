import 'package:flutter/material.dart';
import 'group_information_widget.dart';
import 'action_buttons_widget.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String description;
  final String device;
  final String startDate;
  final String endDate;
  final int timeTolerance;
  final List<String> usersId;
  final String groupId;
  final VoidCallback onDelete;
  final VoidCallback onEdit;


  const GroupCard({
    super.key,
    required this.title,
    required this.description,
    required this.device,
    required this.startDate,
    required this.endDate,
    required this.timeTolerance,
    required this.usersId,
    required this.groupId,
    required this.onDelete,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const CircleAvatar(
            radius: 35.0,
            backgroundColor: Colors.blueAccent,
            child: Icon(
              Icons.group,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          const SizedBox(width: 16.0),

          Expanded(
            child: GroupInformation(
              title: title,
              description: description,
              device: device,
              startDate: startDate,
              endDate: endDate,
              timeTolerance: timeTolerance,
              usersId: usersId,
            ),
          ),

          const SizedBox(width: 16.0),

          ActionButtons(onDelete: onDelete, onEdit: onEdit,),
        ],
      ),
    );
  }
}

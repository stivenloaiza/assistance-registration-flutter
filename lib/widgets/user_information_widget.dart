import 'package:asia_project/widgets/user_labels_widget.dart';
import 'package:flutter/material.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Karina Pineda',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text('C.C. 1.000.762.165'),
                SizedBox(height: 4.0),
                Text('karinadeveloper@gmail.com'),
                SizedBox(height: 8.0),
                UserLabels(),
              ],
            ),
          ),
    );
  }
}

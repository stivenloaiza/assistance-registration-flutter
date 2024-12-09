import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  PaginationWidget({required this.currentPage, required this.totalPages, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

   
    double buttonSize = screenWidth < 400 ? 4 : 12;
    double iconPadding = screenWidth < 400 ? 3 : 8;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: currentPage > 1
              ? () {
                  onPageChanged(currentPage - 1);
                }
              : null,
          child: Icon(Icons.arrow_back, color: currentPage > 1 ? Colors.white : Colors.grey), 
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(iconPadding),
            backgroundColor: currentPage > 1 ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
        SizedBox(width: 8),
  
        for (int i = 1; i <= 3 && i <= totalPages; i++) 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () {
                onPageChanged(i);
              },
              child: Text(i.toString(), style: TextStyle(fontSize: buttonSize)),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(16),
                foregroundColor: Colors.white,
                backgroundColor: currentPage == i
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        if (totalPages > 3) 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('...', style: TextStyle(fontSize: buttonSize)),
          ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: currentPage < totalPages
              ? () {
                  onPageChanged(currentPage + 1);
                }
              : null,
          child: Icon(Icons.arrow_forward, color: currentPage < totalPages ? Colors.white : Colors.grey), 
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(iconPadding),
            backgroundColor: currentPage < totalPages ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }
}

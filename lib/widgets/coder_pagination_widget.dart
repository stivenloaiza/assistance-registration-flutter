import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  PaginationWidget({required this.currentPage, required this.totalPages, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: currentPage > 1
              ? () {
                  onPageChanged(currentPage - 1);
                }
              : null,
          child: Icon(Icons.arrow_back),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(12),
            backgroundColor: currentPage > 1 ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            onPageChanged(1); // Ir a la primera página
          },
          child: Text('1'),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),
            foregroundColor: Colors.white,
            backgroundColor: currentPage == 1
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            onPageChanged(2); // Ir a la segunda página
          },
          child: Text('2'),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),
            foregroundColor: Colors.white,
            backgroundColor: currentPage == 2
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            onPageChanged(3); // Ir a la tercera página
          },
          child: Text('3'),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),
            foregroundColor: Colors.white,
            backgroundColor: currentPage == 3
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 8),
        Text('...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: currentPage < totalPages
              ? () {
                  onPageChanged(currentPage + 1);
                }
              : null,
          child: Icon(Icons.arrow_forward),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(12),
            backgroundColor: currentPage < totalPages ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }
}

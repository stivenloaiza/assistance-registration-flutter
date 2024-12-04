import 'package:flutter/material.dart';

class PageConfig {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const PageConfig({
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });
}
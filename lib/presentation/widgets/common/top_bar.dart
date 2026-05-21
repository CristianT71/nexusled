import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
    required this.showMenu,
    required this.onMenu,
    required this.onProfile,
    required this.onToggleSidebar,
  });

  final String title;
  final bool showMenu;
  final VoidCallback onMenu;
  final VoidCallback onProfile;
  final VoidCallback onToggleSidebar;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.purpleDeep.withValues(alpha: 0.62),
        border: Border(
          bottom: BorderSide(
            color: AppColors.purpleBright.withValues(alpha: 0.18),
          ),
        ),
      ),
      child: Row(
        children: [
          if (showMenu)
            IconButton(onPressed: onMenu, icon: const Icon(Icons.menu_rounded))
          else
            IconButton(
              onPressed: onToggleSidebar,
              icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_rounded),
              ),
              Positioned(
                right: 9,
                top: 9,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: AppColors.magenta,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onProfile,
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.purpleAccent,
              child: Icon(Icons.person_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

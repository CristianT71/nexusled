import 'package:flutter/material.dart';


import 'nexus_visual_styles.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
    required this.showMenu,
    required this.onMenu,
    required this.onProfile,
    required this.onToggleSidebar,
    required this.onSearch,
    required this.onNotifications,
    this.notificationCount = 0,
    this.style = const TopBarStyle(),
  });

  final String title;
  final bool showMenu;
  final VoidCallback onMenu;
  final VoidCallback onProfile;
  final VoidCallback onToggleSidebar;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final int notificationCount;
  final TopBarStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: style.backgroundColor.withValues(alpha: style.backgroundOpacity),
        border: Border(
          bottom: BorderSide(
            color: style.borderColor.withValues(alpha: style.borderOpacity),
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
          IconButton(onPressed: onSearch, icon: const Icon(Icons.search_rounded)),
          Stack(
            children: [
              IconButton(
                onPressed: onNotifications,
                icon: const Icon(Icons.notifications_rounded),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 9,
                  top: 9,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: style.notificationBadgeColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      notificationCount > 9 ? '9+' : '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: onProfile,
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: style.profileAvatarColor,
              child: const Icon(Icons.person_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

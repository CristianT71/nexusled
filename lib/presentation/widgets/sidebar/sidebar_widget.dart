import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../state/nexus_led_state.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({
    super.key,
    required this.current,
    required this.expanded,
    required this.connected,
    required this.userName,
    required this.onSelect,
    required this.onLogout,
  });

  final AppSection current;
  final bool expanded;
  final bool connected;
  final String userName;
  final ValueChanged<AppSection> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: expanded ? 260 : 82,
      decoration: BoxDecoration(
        color: AppColors.purpleDeep.withValues(alpha: 0.92),
        border: Border(
          right: BorderSide(
            color: AppColors.purpleBright.withValues(alpha: 0.22),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            _Header(expanded: expanded),
            const Divider(color: Colors.white12, height: 28),
            _UserMini(
              expanded: expanded,
              connected: connected,
              userName: userName,
            ),
            const Divider(color: Colors.white12, height: 28),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _SectionLabel('PRINCIPAL', expanded: expanded),
                  _Item(
                    section: AppSection.dashboard,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                  _Item(
                    section: AppSection.control,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                  _Item(
                    section: AppSection.statistics,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                  _SectionLabel('INFORMACIÓN', expanded: expanded),
                  _Item(
                    section: AppSection.about,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                  _Item(
                    section: AppSection.services,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                  _Item(
                    section: AppSection.systemInfo,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                  _SectionLabel('CONFIGURACIÓN', expanded: expanded),
                  _Item(
                    section: AppSection.settings,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                  _Item(
                    section: AppSection.support,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                  _Item(
                    section: AppSection.profile,
                    current: current,
                    expanded: expanded,
                    onSelect: onSelect,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded, color: AppColors.ledOff),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.expanded});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: expanded
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        const SizedBox(width: 18),
        const Icon(Icons.bolt_rounded, color: AppColors.purpleGlow, size: 34),
        if (expanded) const SizedBox(width: 10),
        if (expanded)
          const Text(
            'NexusLED',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
      ],
    );
  }
}

class _UserMini extends StatelessWidget {
  const _UserMini({
    required this.expanded,
    required this.connected,
    required this.userName,
  });

  final bool expanded;
  final bool connected;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: expanded
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.purpleAccent,
            child: Icon(Icons.person_rounded),
          ),
          if (expanded) const SizedBox(width: 10),
          if (expanded)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName == '' ? 'Usuario NexusLED' : userName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    connected ? '● Conectado' : '● Desconectado',
                    style: TextStyle(
                      color: connected ? AppColors.ledOn : AppColors.ledOff,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.expanded});

  final String text;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    if (!expanded) return const SizedBox(height: 14);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          letterSpacing: 1.4,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.section,
    required this.current,
    required this.expanded,
    required this.onSelect,
  });

  final AppSection section;
  final AppSection current;
  final bool expanded;
  final ValueChanged<AppSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final active = section == current;
    final icon = switch (section) {
      AppSection.dashboard => Icons.dashboard_rounded,
      AppSection.control => Icons.lightbulb_rounded,
      AppSection.statistics => Icons.area_chart_rounded,
      AppSection.about => Icons.groups_rounded,
      AppSection.services => Icons.rocket_launch_rounded,
      AppSection.systemInfo => Icons.info_rounded,
      AppSection.settings => Icons.settings_rounded,
      AppSection.support => Icons.support_agent_rounded,
      AppSection.profile => Icons.person_rounded,
    };

    return Tooltip(
      message: section.title,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? AppColors.purpleBright.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: active
              ? const Border(
                  left: BorderSide(color: AppColors.purpleGlow, width: 3),
                )
              : null,
        ),
        child: ListTile(
          onTap: () => onSelect(section),
          minLeadingWidth: 24,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: SizedBox(
            width: 24,
            child: Icon(
              icon,
              color: active ? AppColors.purpleGlow : AppColors.textMuted,
            ),
          ),
          title: expanded
              ? Text(
                  section.title,
                  style: TextStyle(
                    color: active
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

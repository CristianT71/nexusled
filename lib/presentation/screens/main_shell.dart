import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_helper.dart';
import '../state/nexus_led_state.dart';
import '../widgets/common/animated_background.dart';
import '../widgets/common/top_bar.dart';
import '../widgets/sidebar/sidebar_widget.dart';
import 'about/about_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'led_control/led_control_screen.dart';
import 'profile/profile_screen.dart';
import 'services/services_screen.dart';
import 'settings/http_settings_screen.dart';
import 'settings/other_protocols_screen.dart';
import 'settings/settings_screen.dart';
import 'statistics/statistics_screen.dart';
import 'support/support_screen.dart';
import 'system_info/system_info_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.state});

  final NexusLedState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: ResponsiveHelper.showSidebar(context)
            ? null
            : Drawer(
                backgroundColor: Colors.transparent,
                child: SidebarWidget(
                  current: state.section,
                  expanded: true,
                  connected: state.mqttConnected,
                  userName:
                      state.profile?.fullName ?? state.profile?.email ?? '',
                  avatarUrl: state.profile?.avatarUrl,
                  onSelect: (section) {
                    Navigator.pop(context);
                    state.setSection(section);
                  },
                  onLogout: state.logout,
                ),
              ),
        body: SafeArea(
          child: Row(
            children: [
              if (ResponsiveHelper.showSidebar(context))
                SidebarWidget(
                  current: state.section,
                  expanded:
                      ResponsiveHelper.isDesktop(context) &&
                      state.sidebarExpanded,
                  connected: state.mqttConnected,
                  userName:
                      state.profile?.fullName ?? state.profile?.email ?? '',
                  avatarUrl: state.profile?.avatarUrl,
                  onSelect: state.setSection,
                  onLogout: state.logout,
                ),
              Expanded(
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        return TopBar(
                          title: state.section.title,
                          showMenu: !ResponsiveHelper.showSidebar(context),
                          onMenu: () => Scaffold.of(context).openDrawer(),
                          onProfile: () => state.setSection(AppSection.profile),
                          onToggleSidebar: state.toggleSidebar,
                          onSearch: () => _showSearchDialog(context, state),
                          onNotifications: () => _showNotificationsDialog(context, state),
                          notificationCount: state.events.length,
                        );
                      },
                    ),
                    Expanded(child: _CurrentScreen(state: state)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSearchDialog(BuildContext context, NexusLedState state) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Buscar eventos'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Buscar por acción, estado...',
          prefixIcon: Icon(Icons.search_rounded),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: Implement search functionality
          },
          child: const Text('Buscar'),
        ),
      ],
    ),
  );
}

void _showNotificationsDialog(BuildContext context, NexusLedState state) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Notificaciones'),
      content: state.events.isEmpty
          ? const Text('No hay eventos recientes')
          : SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return ListTile(
                    leading: Icon(
                      event.action == 'ON' ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                      color: event.action == 'ON' ? AppColors.ledOn : AppColors.ledOff,
                    ),
                    title: Text('${event.action} - ${event.newState}'),
                    subtitle: Text('${event.createdAt} • ${event.latencyMs}ms'),
                  );
                },
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

class _CurrentScreen extends StatelessWidget {
  const _CurrentScreen({required this.state});

  final NexusLedState state;

  @override
  Widget build(BuildContext context) {
    return switch (state.section) {
      AppSection.dashboard => DashboardScreen(
        ledOn: state.ledOn,
        ledColor: state.ledColor,
        events: state.events,
        latencyMs: state.latencyMs,
        stateSince: state.stateSince,
        onOpenControl: () => state.setSection(AppSection.control),
      ),
      AppSection.control => LedControlScreen(
        ledOn: state.ledOn,
        connected: state.mqttConnected,
        config: state.mqttConfig,
        stateSince: state.stateSince,
        latencyMs: state.latencyMs,
        onCommand: state.sendLedCommand,
        ledColor: state.ledColor,
        onColorCommand: state.sendColorCommand,
      ),
      AppSection.statistics => StatisticsScreen(
        events: state.events,
        latencyMs: state.latencyMs,
      ),
      AppSection.about => const AboutScreen(),
      AppSection.services => const ServicesScreen(),
      AppSection.systemInfo => SystemInfoScreen(
        ledOn: state.ledOn,
        connected: state.mqttConnected,
        simulatorActive: state.simulatorActive,
        sent: state.messagesSent,
        received: state.messagesReceived,
        latencyMs: state.latencyMs,
        stateSince: state.stateSince,
        config: state.mqttConfig,
        onReconnect: state.testConnection,
        onSimulatorChanged: state.toggleSimulator,
      ),
      AppSection.connections => SettingsScreen(
        config: state.mqttConfig,
        onSave: state.saveConfiguration,
        onTest: state.testConnection,
      ),
      AppSection.settings => SettingsScreen(
        config: state.mqttConfig,
        onSave: state.saveConfiguration,
        onTest: state.testConnection,
      ),
      AppSection.httpSettings => const HttpSettingsScreen(),
      AppSection.otherProtocols => const OtherProtocolsScreen(),
      AppSection.support => const SupportScreen(),
      AppSection.profile => ProfileScreen(
        profile: state.profile,
        onLogout: state.logout,
        onUpdateProfile: state.updateProfile,
        onUploadAvatar: state.uploadAvatar,
      ),
    };
  }
}

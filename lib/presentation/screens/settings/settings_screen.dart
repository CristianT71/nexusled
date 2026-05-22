import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/mqtt_config_model.dart';
import '../../../data/models/supabase_config_model.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';
import '../../widgets/mqtt_connection_test_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.config,
    required this.supabaseConfig,
    required this.onSave,
    required this.onTest,
  });

  final MqttConfigModel config;
  final SupabaseConfigModel supabaseConfig;
  final Future<void> Function() onSave;
  final Future<Map<String, dynamic>> Function() onTest;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _name;
  late final TextEditingController _host;
  late final TextEditingController _port;
  late final TextEditingController _wsPort;
  late final TextEditingController _controlTopic;
  late final TextEditingController _statusTopic;
  late final TextEditingController _colorTopic;
  late final TextEditingController _heartbeatTopic;
  late final TextEditingController _clientId;
  late final TextEditingController _keepAlive;
  late final TextEditingController _mqttUsername;
  late final TextEditingController _mqttPassword;
  late final TextEditingController _supabaseUrl;
  late final TextEditingController _supabaseAnonKey;

  @override
  void initState() {
    super.initState();
    final config = widget.config;
    _name = TextEditingController(text: config.configName);
    _host = TextEditingController(text: config.brokerHost);
    _port = TextEditingController(text: '${config.brokerPort}');
    _wsPort = TextEditingController(text: '${config.websocketPort}');
    _controlTopic = TextEditingController(text: config.topicControl);
    _statusTopic = TextEditingController(text: config.topicStatus);
    _colorTopic = TextEditingController(text: config.topicColor);
    _heartbeatTopic = TextEditingController(text: config.topicHeartbeat);
    _clientId = TextEditingController(text: config.clientId);
    _keepAlive = TextEditingController(text: '${config.keepAlive}');
    _mqttUsername = TextEditingController(text: config.username);
    _mqttPassword = TextEditingController(text: config.password);
    _supabaseUrl = TextEditingController(
      text: widget.supabaseConfig.projectUrl,
    );
    _supabaseAnonKey = TextEditingController(
      text: widget.supabaseConfig.anonKey,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _host.dispose();
    _port.dispose();
    _wsPort.dispose();
    _controlTopic.dispose();
    _statusTopic.dispose();
    _colorTopic.dispose();
    _heartbeatTopic.dispose();
    _clientId.dispose();
    _keepAlive.dispose();
    _mqttUsername.dispose();
    _mqttPassword.dispose();
    _supabaseUrl.dispose();
    _supabaseAnonKey.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final config = widget.config;
    config.configName = _name.text;
    config.brokerHost = _host.text;
    config.brokerPort = int.tryParse(_port.text) ?? config.brokerPort;
    config.websocketPort = int.tryParse(_wsPort.text) ?? config.websocketPort;
    config.topicControl = _controlTopic.text;
    config.topicStatus = _statusTopic.text;
    config.topicColor = _colorTopic.text;
    config.topicHeartbeat = _heartbeatTopic.text;
    config.clientId = _clientId.text;
    config.keepAlive = int.tryParse(_keepAlive.text) ?? config.keepAlive;
    config.username = _mqttUsername.text;
    config.password = _mqttPassword.text;
    widget.supabaseConfig.projectUrl = _supabaseUrl.text;
    widget.supabaseConfig.anonKey = _supabaseAnonKey.text;
    await widget.onSave();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración MQTT guardada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuración MQTT y Supabase',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toda la configuración vive dentro de la app. No se usa .env para MQTT ni Supabase.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            _Field(
              controller: _name,
              label: 'Nombre del perfil',
              icon: Icons.badge_rounded,
            ),
            _Field(
              controller: _host,
              label: 'Servidor Broker MQTT',
              icon: Icons.dns_rounded,
            ),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    controller: _port,
                    label: 'Puerto MQTT',
                    icon: Icons.settings_ethernet_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Field(
                    controller: _wsPort,
                    label: 'Puerto WebSocket',
                    icon: Icons.language_rounded,
                  ),
                ),
              ],
            ),
            _Field(
              controller: _controlTopic,
              label: 'Tópico de Control',
              icon: Icons.outbox_rounded,
            ),
            _Field(
              controller: _statusTopic,
              label: 'Tópico de Estado',
              icon: Icons.move_to_inbox_rounded,
            ),
            _Field(
              controller: _colorTopic,
              label: 'Tópico de Color',
              icon: Icons.palette_rounded,
            ),
            _Field(
              controller: _heartbeatTopic,
              label: 'Tópico de Heartbeat',
              icon: Icons.favorite_rounded,
            ),
            _Field(
              controller: _clientId,
              label: 'Client ID',
              icon: Icons.fingerprint_rounded,
            ),
            _Field(
              controller: _keepAlive,
              label: 'Keep Alive',
              icon: Icons.timer_rounded,
            ),
            _Field(
              controller: _mqttUsername,
              label: 'Usuario MQTT',
              icon: Icons.person_rounded,
            ),
            _Field(
              controller: _mqttPassword,
              label: 'Contraseña MQTT',
              icon: Icons.password_rounded,
              obscure: true,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: widget.config.useSsl,
              title: const Text('Usar SSL/TLS'),
              onChanged: (value) =>
                  setState(() => widget.config.useSsl = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: widget.config.retain,
              title: const Text('Retained Messages'),
              onChanged: (value) =>
                  setState(() => widget.config.retain = value),
            ),
            const Divider(color: Colors.white12, height: 34),
            const Text(
              'Supabase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _supabaseUrl,
              label: 'Project URL',
              icon: Icons.link_rounded,
            ),
            _Field(
              controller: _supabaseAnonKey,
              label: 'Anon Key',
              icon: Icons.vpn_key_rounded,
              obscure: true,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: widget.supabaseConfig.enabled,
              title: const Text('Activar Supabase Auth / Database'),
              onChanged: (value) =>
                  setState(() => widget.supabaseConfig.enabled = value),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                NexusButton(
                  label: 'PROBAR CONEXIÓN',
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => MqttConnectionTestDialog(
                        onTest: widget.onTest,
                      ),
                    );
                  },
                  icon: Icons.wifi_tethering_rounded,
                ),
                NexusButton(
                  label: 'GUARDAR CONFIGURACIÓN',
                  onPressed: _save,
                  icon: Icons.save_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }
}

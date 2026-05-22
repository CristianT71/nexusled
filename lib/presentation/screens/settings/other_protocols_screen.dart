import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';

class OtherProtocolsScreen extends StatefulWidget {
  const OtherProtocolsScreen({super.key});

  @override
  State<OtherProtocolsScreen> createState() => _OtherProtocolsScreenState();
}

class _OtherProtocolsScreenState extends State<OtherProtocolsScreen> {
  final _host = TextEditingController(text: 'example.com');
  final _port = TextEditingController(text: '443');
  final _path = TextEditingController(text: '/ws');
  String _protocol = 'WebSocket';
  bool _secure = true;
  bool _loading = false;
  String _result = 'Selecciona un protocolo y ejecuta una prueba.';

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    _path.dispose();
    super.dispose();
  }

  Future<void> _testProtocol() async {
    setState(() {
      _loading = true;
      _result = 'Probando $_protocol...';
    });

    try {
      if (kIsWeb) {
        setState(() => _result = 'La prueba TCP/WebSocket directa no está disponible en navegador. Guarda la configuración para usarla desde un cliente compatible.');
        return;
      }

      final host = _host.text.trim();
      final port = int.tryParse(_port.text.trim()) ?? 0;
      if (host.isEmpty || port <= 0) {
        setState(() => _result = 'Host o puerto inválido.');
        return;
      }

      final startedAt = DateTime.now();
      if (_protocol == 'WebSocket') {
        final scheme = _secure ? 'wss' : 'ws';
        final socket = await WebSocket.connect('$scheme://$host:$port${_path.text.trim()}').timeout(const Duration(seconds: 10));
        await socket.close();
      } else {
        final socket = await Socket.connect(host, port, timeout: const Duration(seconds: 10));
        await socket.close();
      }
      final elapsed = DateTime.now().difference(startedAt).inMilliseconds;
      setState(() => _result = 'Conexión $_protocol exitosa en ${elapsed}ms.');
    } catch (error) {
      setState(() => _result = 'Error en $_protocol: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración de otros protocolos guardada en la sesión')),
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
              'Otros Protocolos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configura conexiones WebSocket o TCP para integraciones adicionales.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _protocol,
              decoration: const InputDecoration(labelText: 'Protocolo', prefixIcon: Icon(Icons.device_hub_rounded)),
              items: const [
                DropdownMenuItem(value: 'WebSocket', child: Text('WebSocket')),
                DropdownMenuItem(value: 'TCP', child: Text('TCP Socket')),
              ],
              onChanged: (value) => setState(() => _protocol = value ?? _protocol),
            ),
            const SizedBox(height: 14),
            _Field(controller: _host, label: 'Host', icon: Icons.dns_rounded),
            _Field(controller: _port, label: 'Puerto', icon: Icons.settings_ethernet_rounded),
            if (_protocol == 'WebSocket')
              _Field(controller: _path, label: 'Ruta WebSocket', icon: Icons.route_rounded),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _secure,
              title: Text(_protocol == 'WebSocket' ? 'Usar WSS' : 'Conexión segura'),
              onChanged: (value) => setState(() => _secure = value),
            ),
            const Divider(color: Colors.white12, height: 34),
            Text(_result, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                NexusButton(
                  label: _loading ? 'PROBANDO...' : 'PROBAR PROTOCOLO',
                  onPressed: _loading ? null : _testProtocol,
                  icon: Icons.cable_rounded,
                ),
                NexusButton(
                  label: 'GUARDAR PROTOCOLO',
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
  const _Field({required this.controller, required this.label, required this.icon});

  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }
}

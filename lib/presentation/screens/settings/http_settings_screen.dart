import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';

class HttpSettingsScreen extends StatefulWidget {
  const HttpSettingsScreen({super.key});

  @override
  State<HttpSettingsScreen> createState() => _HttpSettingsScreenState();
}

class _HttpSettingsScreenState extends State<HttpSettingsScreen> {
  final _baseUrl = TextEditingController(text: 'https://example.com');
  final _endpoint = TextEditingController(text: '/api/led/status');
  final _token = TextEditingController();
  String _method = 'GET';
  bool _useHttps = true;
  bool _loading = false;
  String _result = 'Sin pruebas ejecutadas.';

  @override
  void dispose() {
    _baseUrl.dispose();
    _endpoint.dispose();
    _token.dispose();
    super.dispose();
  }

  Future<void> _testHttpConnection() async {
    setState(() {
      _loading = true;
      _result = 'Probando conexión HTTP...';
    });

    try {
      final base = _baseUrl.text.trim();
      final endpoint = _endpoint.text.trim();
      final uri = Uri.parse('$base$endpoint');
      final headers = <String, String>{
        if (_token.text.trim().isNotEmpty) 'Authorization': 'Bearer ${_token.text.trim()}',
      };
      final startedAt = DateTime.now();
      final response = _method == 'POST'
          ? await http.post(uri, headers: headers).timeout(const Duration(seconds: 10))
          : await http.get(uri, headers: headers).timeout(const Duration(seconds: 10));
      final elapsed = DateTime.now().difference(startedAt).inMilliseconds;

      setState(() {
        _result = 'HTTP ${response.statusCode} en ${elapsed}ms. Respuesta: ${response.body.isEmpty ? 'Sin contenido' : response.body.substring(0, response.body.length > 180 ? 180 : response.body.length)}';
      });
    } catch (error) {
      setState(() => _result = 'Error HTTP: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración HTTP guardada en la sesión')),
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
              'Configuración HTTP',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configura un endpoint REST para consultar o enviar comandos desde NexusLED.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            _Field(controller: _baseUrl, label: 'URL base', icon: Icons.link_rounded),
            _Field(controller: _endpoint, label: 'Endpoint', icon: Icons.api_rounded),
            _Field(controller: _token, label: 'Bearer token opcional', icon: Icons.vpn_key_rounded, obscure: true),
            DropdownButtonFormField<String>(
              initialValue: _method,
              decoration: const InputDecoration(labelText: 'Método HTTP', prefixIcon: Icon(Icons.sync_alt_rounded)),
              items: const [
                DropdownMenuItem(value: 'GET', child: Text('GET')),
                DropdownMenuItem(value: 'POST', child: Text('POST')),
              ],
              onChanged: (value) => setState(() => _method = value ?? _method),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _useHttps,
              title: const Text('Preferir HTTPS'),
              onChanged: (value) => setState(() => _useHttps = value),
            ),
            const Divider(color: Colors.white12, height: 34),
            Text(_result, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                NexusButton(
                  label: _loading ? 'PROBANDO...' : 'PROBAR HTTP',
                  onPressed: _loading ? null : _testHttpConnection,
                  icon: Icons.http_rounded,
                ),
                NexusButton(
                  label: 'GUARDAR HTTP',
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
  const _Field({required this.controller, required this.label, required this.icon, this.obscure = false});

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

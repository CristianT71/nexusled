import 'package:flutter/material.dart';

import 'common/glass_card.dart';
import 'common/nexus_button.dart';
import '../../core/constants/app_colors.dart';

class MqttConnectionTestDialog extends StatefulWidget {
  const MqttConnectionTestDialog({
    super.key,
    required this.onTest,
  });

  final Future<Map<String, dynamic>> Function() onTest;

  @override
  State<MqttConnectionTestDialog> createState() => _MqttConnectionTestDialogState();
}

class _MqttConnectionTestDialogState extends State<MqttConnectionTestDialog> {
  bool _testing = false;
  Map<String, dynamic>? _result;

  Future<void> _runTest() async {
    setState(() {
      _testing = true;
      _result = null;
    });

    try {
      final result = await widget.onTest();
      setState(() {
        _result = result;
        _testing = false;
      });
    } catch (e) {
      setState(() {
        _result = {'success': false, 'details': {'error': e.toString()}};
        _testing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.purpleDeep,
      title: const Text(
        'Prueba de Conexión MQTT',
        style: TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_testing)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Probando conexión...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            else if (_result != null) ...[
              _buildResult(),
            ] else
              const Text(
                'Haz clic en "Probar" para verificar la conexión con el broker MQTT.',
                style: TextStyle(color: Colors.white70),
              ),
          ],
        ),
      ),
      actions: [
        NexusButton(
          label: 'PROBAR',
          onPressed: _testing ? null : _runTest,
          icon: Icons.wifi_tethering_rounded,
        ),
        NexusButton(
          label: 'CERRAR',
          onPressed: () => Navigator.pop(context),
          icon: Icons.close_rounded,
        ),
      ],
    );
  }

  Widget _buildResult() {
    final success = _result!['success'] == true;
    final details = _result!['details'] as Map<String, dynamic>;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                success ? Icons.check_circle_rounded : Icons.error_rounded,
                color: success ? AppColors.ledOn : AppColors.ledOff,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  success ? 'Conexión Exitosa' : 'Error de Conexión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: success ? AppColors.ledOn : AppColors.ledOff,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailRow('Broker', details['broker']?.toString() ?? 'N/A'),
          _DetailRow('Plataforma', details['platform']?.toString() ?? 'N/A'),
          _DetailRow('Puerto Detectado', details['detected_port']?.toString() ?? 'N/A'),
          _DetailRow('Path Detectado', details['detected_path']?.toString() ?? 'N/A'),
          _DetailRow('SSL Detectado', details['detected_ssl']?.toString() ?? 'N/A'),
          if (details['websocket_url'] != null)
            _DetailRow('URL WebSocket', details['websocket_url'].toString()),
          if (details['status'] != null)
            _DetailRow('Estado', details['status'].toString()),
          if (details['publish_test'] != null)
            _DetailRow('Prueba Publicación', details['publish_test'].toString()),
          if (details['error'] != null)
            _DetailRow('Error', details['error'].toString(), isError: true),
          if (details['suggestion'] != null)
            _DetailRow('Sugerencia', details['suggestion'].toString(), isSuggestion: true),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, {this.isError = false, this.isSuggestion = false});

  final String label;
  final String value;
  final bool isError;
  final bool isSuggestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isError
                    ? AppColors.ledOff
                    : isSuggestion
                        ? AppColors.ledOn
                        : Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

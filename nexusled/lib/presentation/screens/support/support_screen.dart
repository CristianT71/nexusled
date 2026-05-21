import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Centro de Ayuda',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'Encuentra respuestas a las preguntas más comunes y soluciona problemas de conexión.',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Preguntas Frecuentes (FAQ)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 12),
                _Faq(
                  question: '¿Cómo conectar el Arduino por primera vez?',
                  answer:
                      'Asegúrate de que tu Arduino Nano ESP32 esté conectado a WiFi. Configura el broker MQTT (host, puerto, usuario y contraseña) en la pantalla de Configuración. El LED debe conectarse automáticamente si la configuración es correcta.',
                ),
                _Faq(
                  question: '¿Por qué el LED no responde?',
                  answer:
                      'Verifica que: 1) El Arduino esté encendido y conectado. 2) Ambas redes (Arduino y app) tengan acceso al mismo broker. 3) Los tópicos sean los mismos (light-bulb para comandos). 4) El usuario y contraseña MQTT sean correctos.',
                ),
                _Faq(
                  question: '¿Qué es un tópico MQTT?',
                  answer:
                      'Un tópico es como una dirección de correo para mensajes. El Arduino se suscribe a "light-bulb" para recibir órdenes de encender/apagar. La app publica órdenes en ese tópico. Ambos deben usar exactamente el mismo nombre.',
                ),
                _Faq(
                  question: '¿Qué pasa si pierdo conexión a Internet?',
                  answer:
                      'Los comandos requieren conexión a Internet para alcanzar el broker MQTT. Si pierdes conexión, espera a reconectar. Con QoS 1, el broker intenta garantizar que los mensajes lleguen cuando se reconecte.',
                ),
                _Faq(
                  question:
                      '¿Es seguro controlar dispositivos desde cualquier lado?',
                  answer:
                      'NexusLED implementa autenticación (usuario/contraseña MQTT) y puede usar TLS/SSL para encriptar. En producción, es recomendable usar conexiones seguras y cambiar las credenciales por defecto.',
                ),
                _Faq(
                  question:
                      '¿Puedo usar un broker MQTT local en lugar de EMQX?',
                  answer:
                      'Sí. Puedes instalar Mosquitto o cualquier broker MQTT en tu red local. Configura el host como la IP de tu servidor local y el puerto como 1883 (TCP) o 8080 (WebSocket).',
                ),
                _Faq(
                  question: '¿Qué significa la latencia en milisegundos?',
                  answer:
                      'Es el tiempo entre que envías una orden y el Arduino la recibe. Menos de 100ms es bueno. Si es mayor, indica congestión de red o broker lejano. Acerca el broker a tu ubicación si es posible.',
                ),
                _Faq(
                  question: '¿Cómo monitorear los comandos enviados?',
                  answer:
                      'En la pantalla "Info del Sistema" puedes ver el contador de mensajes enviados y recibidos. La aplicación registra cada acción y latencia para análisis.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solución de Problemas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                _TroubleshootingItem(
                  issue: 'Conexión rechazada',
                  steps: [
                    'Verifica el host y puerto del broker',
                    'Confirma usuario y contraseña MQTT',
                    'Asegúrate que el broker esté ejecutándose',
                    'Comprueba la conectividad de red',
                  ],
                ),
                _TroubleshootingItem(
                  issue: 'Arduino no recibe órdenes',
                  steps: [
                    'Revisa el sketch en Arduino IDE',
                    'Confirma que se suscribe al tópico correcto',
                    'Verifica los pines GPIO configurados',
                    'Comprueba la conexión del LED',
                  ],
                ),
                _TroubleshootingItem(
                  issue: 'Latencia muy alta (>1000ms)',
                  steps: [
                    'Reduce la distancia o cambia a broker más cercano',
                    'Verifica ancho de banda disponible',
                    'Reduce otros procesos que usen red',
                    'Prueba con QoS 0 si es tolerable',
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contacto y Soporte',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                _ContactItem(
                  icon: Icons.mail_rounded,
                  label: 'Correo Electrónico',
                  value: 'soporte@nexusled.local',
                ),
                const SizedBox(height: 10),
                _ContactItem(
                  icon: Icons.school_rounded,
                  label: 'SENA - Centro de Formación',
                  value: 'Tecnologo en Análisis y Desarrollo de Software',
                ),
                const SizedBox(height: 10),
                _ContactItem(
                  icon: Icons.description_rounded,
                  label: 'Documentación',
                  value: 'Ver archivos README en el repositorio',
                ),
                const SizedBox(height: 16),
                NexusButton(
                  label: 'ABRIR DOCUMENTACIÓN',
                  icon: Icons.open_in_new_rounded,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Documentación disponible en el repositorio',
                      ),
                    ),
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

class _Faq extends StatelessWidget {
  const _Faq({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      iconColor: AppColors.accentGlow,
      collapsedIconColor: AppColors.textMuted,
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            answer,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _TroubleshootingItem extends StatelessWidget {
  const _TroubleshootingItem({required this.issue, required this.steps});

  final String issue;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_rounded, color: AppColors.neonBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                issue,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.neonBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...steps.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 6),
              child: Text(
                '${e.key + 1}. ${e.value}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.brightBlue, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.brightBlue,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

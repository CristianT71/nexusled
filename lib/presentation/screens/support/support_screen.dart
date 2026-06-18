import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';
import '../../widgets/common/nexus_visual_styles.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const faqQuestionStyle = TextStyle(fontWeight: FontWeight.w800);
    const faqAnswerStyle = TextStyle(
      color: AppColors.textSecondary,
      height: 1.5,
    );
    const troubleshootingStyle = NexusInfoTileStyle(
      iconColor: AppColors.neonBlue,
      titleStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.neonBlue,
      ),
      descriptionStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
      ),
      iconSize: 20,
      gap: 8,
      bottomPadding: 14,
    );
    const contactStyle = NexusInfoTileStyle(
      iconColor: AppColors.brightBlue,
      titleStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.brightBlue,
        fontSize: 12,
      ),
      descriptionStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
      ),
      iconSize: 20,
      gap: 10,
      bottomPadding: 0,
    );

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
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
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
                  questionStyle: faqQuestionStyle,
                  answerStyle: faqAnswerStyle,
                  expandedIconColor: AppColors.accentGlow,
                  collapsedIconColor: AppColors.textMuted,
                ),
                _Faq(
                  question: '¿Por qué el LED no responde?',
                  answer:
                      'Verifica que: 1) El Arduino esté encendido y conectado. 2) Ambas redes (Arduino y app) tengan acceso al mismo broker. 3) Los tópicos sean los mismos (light-bulb para comandos). 4) El usuario y contraseña MQTT sean correctos.',
                  questionStyle: faqQuestionStyle,
                  answerStyle: faqAnswerStyle,
                  expandedIconColor: AppColors.accentGlow,
                  collapsedIconColor: AppColors.textMuted,
                ),
                _Faq(
                  question: '¿Qué es un tópico MQTT?',
                  answer:
                      'Un tópico es como una dirección de correo para mensajes. El Arduino se suscribe a "light-bulb" para recibir órdenes de encender/apagar. La app publica órdenes en ese tópico. Ambos deben usar exactamente el mismo nombre.',
                  questionStyle: faqQuestionStyle,
                  answerStyle: faqAnswerStyle,
                  expandedIconColor: AppColors.accentGlow,
                  collapsedIconColor: AppColors.textMuted,
                ),
                _Faq(
                  question: '¿Qué pasa si pierdo conexión a Internet?',
                  answer:
                      'Los comandos requieren conexión a Internet para alcanzar el broker MQTT. Si pierdes conexión, espera a reconectar. Con QoS 1, el broker intenta garantizar que los mensajes lleguen cuando se reconecte.',
                  questionStyle: faqQuestionStyle,
                  answerStyle: faqAnswerStyle,
                  expandedIconColor: AppColors.accentGlow,
                  collapsedIconColor: AppColors.textMuted,
                ),
                _Faq(
                  question:
                      '¿Es seguro controlar dispositivos desde cualquier lado?',
                  answer:
                      'NexusLED implementa autenticación (usuario/contraseña MQTT) y puede usar TLS/SSL para encriptar. En producción, es recomendable usar conexiones seguras y cambiar las credenciales por defecto.',
                  questionStyle: faqQuestionStyle,
                  answerStyle: faqAnswerStyle,
                  expandedIconColor: AppColors.accentGlow,
                  collapsedIconColor: AppColors.textMuted,
                ),
                _Faq(
                  question:
                      '¿Puedo usar un broker MQTT local en lugar de EMQX?',
                  answer:
                      'Sí. Puedes instalar Mosquitto o cualquier broker MQTT en tu red local. Configura el host como la IP de tu servidor local y el puerto como 1883 (TCP) o 8080 (WebSocket).',
                  questionStyle: faqQuestionStyle,
                  answerStyle: faqAnswerStyle,
                  expandedIconColor: AppColors.accentGlow,
                  collapsedIconColor: AppColors.textMuted,
                ),
                _Faq(
                  question: '¿Qué significa la latencia en milisegundos?',
                  answer:
                      'Es el tiempo entre que envías una orden y el Arduino la recibe. Menos de 100ms es bueno. Si es mayor, indica congestión de red o broker lejano. Acerca el broker a tu ubicación si es posible.',
                  questionStyle: faqQuestionStyle,
                  answerStyle: faqAnswerStyle,
                  expandedIconColor: AppColors.accentGlow,
                  collapsedIconColor: AppColors.textMuted,
                ),
                _Faq(
                  question: '¿Cómo monitorear los comandos enviados?',
                  answer:
                      'En la pantalla "Info del Sistema" puedes ver el contador de mensajes enviados y recibidos. La aplicación registra cada acción y latencia para análisis.',
                  questionStyle: faqQuestionStyle,
                  answerStyle: faqAnswerStyle,
                  expandedIconColor: AppColors.accentGlow,
                  collapsedIconColor: AppColors.textMuted,
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
                  'Solución de Problemas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 12),
                _TroubleshootingItem(
                  issue: 'Conexión rechazada',
                  steps: [
                    'Verifica el host y puerto del broker',
                    'Confirma usuario y contraseña MQTT',
                    'Asegúrate que el broker esté ejecutándose',
                    'Comprueba la conectividad de red',
                  ],
                  style: troubleshootingStyle,
                ),
                _TroubleshootingItem(
                  issue: 'Arduino no recibe órdenes',
                  steps: [
                    'Revisa el sketch en Arduino IDE',
                    'Confirma que se suscribe al tópico correcto',
                    'Verifica los pines GPIO configurados',
                    'Comprueba la conexión del LED',
                  ],
                  style: troubleshootingStyle,
                ),
                _TroubleshootingItem(
                  issue: 'Latencia muy alta (>1000ms)',
                  steps: [
                    'Reduce la distancia o cambia a broker más cercano',
                    'Verifica ancho de banda disponible',
                    'Reduce otros procesos que usen red',
                    'Prueba con QoS 0 si es tolerable',
                  ],
                  style: troubleshootingStyle,
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
                const _ContactItem(
                  icon: Icons.mail_rounded,
                  label: 'Correo Electrónico',
                  value: 'soporte@nexusled.local',
                  style: contactStyle,
                ),
                const SizedBox(height: 10),
                const _ContactItem(
                  icon: Icons.school_rounded,
                  label: 'SENA - Centro de Formación',
                  value: 'Tecnologo en Análisis y Desarrollo de Software',
                  style: contactStyle,
                ),
                const SizedBox(height: 10),
                const _ContactItem(
                  icon: Icons.description_rounded,
                  label: 'Documentación',
                  value: 'Ver archivos README en el repositorio',
                  style: contactStyle,
                ),
                const SizedBox(height: 16),
                NexusButton(
                  label: 'ABRIR DOCUMENTACIÓN',
                  icon: Icons.open_in_new_rounded,
                  style: const NexusButtonStyle(
                    gradientColors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    borderColor: Color(0xFF38BDF8),
                    borderWidth: 1,
                    shadowOpacity: 0.2,
                  ),
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
  const _Faq({
    required this.question,
    required this.answer,
    required this.questionStyle,
    required this.answerStyle,
    required this.expandedIconColor,
    required this.collapsedIconColor,
  });

  final String question;
  final String answer;
  final TextStyle questionStyle;
  final TextStyle answerStyle;
  final Color expandedIconColor;
  final Color collapsedIconColor;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      iconColor: expandedIconColor,
      collapsedIconColor: collapsedIconColor,
      title: Text(question, style: questionStyle),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(answer, style: answerStyle),
        ),
      ],
    );
  }
}

class _TroubleshootingItem extends StatelessWidget {
  const _TroubleshootingItem({
    required this.issue,
    required this.steps,
    required this.style,
  });

  final String issue;
  final List<String> steps;
  final NexusInfoTileStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: style.bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_rounded, color: style.iconColor, size: style.iconSize),
              SizedBox(width: style.gap),
              Text(issue, style: style.titleStyle),
            ],
          ),
          const SizedBox(height: 8),
          ...steps.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 6),
              child: Text('${e.key + 1}. ${e.value}', style: style.descriptionStyle),
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
    required this.style,
  });

  final IconData icon;
  final String label;
  final String value;
  final NexusInfoTileStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: style.iconColor, size: style.iconSize),
        SizedBox(width: style.gap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: style.titleStyle),
              Text(value, style: style.descriptionStyle),
            ],
          ),
        ),
      ],
    );
  }
}

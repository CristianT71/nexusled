import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'iot_light_cubit.dart';
import 'iot_light_state.dart';

enum ConnectionTransport {
  auto,
  tcp,
  websocket,
}

extension ConnectionTransportLabel on ConnectionTransport {
  String get label => switch (this) {
        ConnectionTransport.auto => 'Automático',
        ConnectionTransport.tcp => 'MQTT TCP',
        ConnectionTransport.websocket => 'WebSocket',
      };
}

String defaultBrokerHost() {
  if (kIsWeb) {
    return 'localhost';
  }

  final platform = defaultTargetPlatform;
  if (platform == TargetPlatform.android) {
    return '10.0.2.2';
  }

  return 'localhost';
}

class BrokerConfig {
  final String host;
  final int tcpPort;
  final int websocketPort;
  final String websocketPath;
  final String clientId;
  final ConnectionTransport transport;
  final bool useTls;

  const BrokerConfig({
    required this.host,
    required this.tcpPort,
    required this.websocketPort,
    required this.websocketPath,
    required this.clientId,
    required this.transport,
    required this.useTls,
  });

  factory BrokerConfig.defaults() {
    return BrokerConfig(
      host: defaultBrokerHost(),
      tcpPort: 1883,
      websocketPort: 8080,
      websocketPath: '/',
      clientId: 'light-controller-app',
      transport: ConnectionTransport.auto,
      useTls: false,
    );
  }

  bool get useWebSocket =>
      transport == ConnectionTransport.websocket ||
      (transport == ConnectionTransport.auto && kIsWeb);
}

MqttClient createClient(BrokerConfig config) {
  if (config.useWebSocket) {
    final scheme = config.useTls ? 'wss' : 'ws';
    final path = config.websocketPath.startsWith('/')
        ? config.websocketPath
        : '/${config.websocketPath}';
    final uri = Uri(
      scheme: scheme,
      host: config.host,
      port: config.websocketPort,
      path: path,
    );
    final client = MqttBrowserClient.withPort(
      uri.toString(),
      config.clientId,
      config.websocketPort,
    );
    client.websocketProtocols = const ['mqtt'];
    return client;
  }

  final client = MqttServerClient.withPort(
    config.host,
    config.clientId,
    config.tcpPort,
  );
  client.secure = config.useTls;
  return client;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Light Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const BrokerConnectionShell(),
    );
  }
}

class BrokerConnectionShell extends StatefulWidget {
  const BrokerConnectionShell({super.key});

  @override
  State<BrokerConnectionShell> createState() => _BrokerConnectionShellState();
}

class _BrokerConnectionShellState extends State<BrokerConnectionShell> {
  IotLightBloc? _bloc;
  BrokerConfig? _config;
  bool _connecting = false;

  Future<void> _connect(
    BrokerConfig config,
    String? username,
    String? password,
  ) async {
    final mqttClient = createClient(config);
    mqttClient.logging(on: true);

    final bloc = IotLightBloc(mqttClient: mqttClient);

    setState(() {
      _connecting = true;
    });

    try {
      await bloc.connect(
        username?.trim().isEmpty ?? true ? null : username!.trim(),
        password?.isEmpty ?? true ? null : password,
      );

      if (!mounted) {
        await bloc.close();
        return;
      }

      setState(() {
        _bloc = bloc;
        _config = config;
        _connecting = false;
      });
    } catch (error) {
      await bloc.close();

      if (!mounted) {
        return;
      }

      setState(() {
        _connecting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo conectar: $error')),
      );
    }
  }

  Future<void> _disconnect() async {
    final bloc = _bloc;
    setState(() {
      _bloc = null;
      _config = null;
    });

    await bloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = _bloc;
    final config = _config;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: bloc == null || config == null
          ? BrokerConnectionForm(
              key: const ValueKey('connection-form'),
              connecting: _connecting,
              onConnect: _connect,
            )
          : BlocProvider.value(
              value: bloc,
              child: LightControllerView(
                key: const ValueKey('controller-view'),
                config: config,
                onDisconnect: _disconnect,
              ),
            ),
    );
  }
}

class BrokerConnectionForm extends StatefulWidget {
  final bool connecting;
  final Future<void> Function(
    BrokerConfig config,
    String? username,
    String? password,
  ) onConnect;

  const BrokerConnectionForm({
    super.key,
    required this.connecting,
    required this.onConnect,
  });

  @override
  State<BrokerConnectionForm> createState() => _BrokerConnectionFormState();
}

class _BrokerConnectionFormState extends State<BrokerConnectionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _hostController;
  late final TextEditingController _tcpPortController;
  late final TextEditingController _webSocketPortController;
  late final TextEditingController _webSocketPathController;
  late final TextEditingController _clientIdController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late ConnectionTransport _transport;
  late bool _useTls;

  @override
  void initState() {
    super.initState();
    final defaults = BrokerConfig.defaults();
    _hostController = TextEditingController(text: defaults.host);
    _tcpPortController =
        TextEditingController(text: defaults.tcpPort.toString());
    _webSocketPortController = TextEditingController(
      text: defaults.websocketPort.toString(),
    );
    _webSocketPathController =
        TextEditingController(text: defaults.websocketPath);
    _clientIdController = TextEditingController(text: defaults.clientId);
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _transport = defaults.transport;
    _useTls = defaults.useTls;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _tcpPortController.dispose();
    _webSocketPortController.dispose();
    _webSocketPathController.dispose();
    _clientIdController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final config = BrokerConfig(
      host: _hostController.text.trim(),
      tcpPort: int.parse(_tcpPortController.text.trim()),
      websocketPort: int.parse(_webSocketPortController.text.trim()),
      websocketPath: _webSocketPathController.text.trim().isEmpty
          ? '/'
          : _webSocketPathController.text.trim(),
      clientId: _clientIdController.text.trim(),
      transport: _transport,
      useTls: _useTls,
    );

    await widget.onConnect(
      config,
      _usernameController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ConnectionTransport> availableTransports = kIsWeb
        ? const [ConnectionTransport.auto, ConnectionTransport.websocket]
        : ConnectionTransport.values.toList(growable: false);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Conectar a un broker MQTT',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Funciona con Mosquitto, EMQX y otros brokers compatibles. En web se usa WebSocket; en móvil y escritorio puedes usar TCP o WebSocket.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _hostController,
                            enabled: !widget.connecting,
                            decoration: const InputDecoration(
                              labelText: 'Host o IP del broker',
                              hintText:
                                  'localhost, 192.168.1.10, broker.emqx.io',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Ingresa un host válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<ConnectionTransport>(
                            initialValue: _transport,
                            items: availableTransports
                                .map(
                                  (transport) => DropdownMenuItem(
                                    value: transport,
                                    child: Text(transport.label),
                                  ),
                                )
                                .toList(),
                            onChanged: widget.connecting
                                ? null
                                : (value) {
                                    if (value == null) {
                                      return;
                                    }
                                    setState(() {
                                      _transport = value;
                                    });
                                  },
                            decoration: const InputDecoration(
                              labelText: 'Transporte',
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (kIsWeb)
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'En web solo está disponible WebSocket.',
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _tcpPortController,
                                  enabled: !widget.connecting,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Puerto MQTT TCP',
                                    hintText: '1883',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Ingresa un puerto';
                                    }
                                    final port = int.tryParse(value.trim());
                                    if (port == null ||
                                        port <= 0 ||
                                        port > 65535) {
                                      return 'Puerto inválido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _webSocketPortController,
                                  enabled: !widget.connecting,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Puerto WebSocket',
                                    hintText: '8080, 8083 o 8084',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Ingresa un puerto';
                                    }
                                    final port = int.tryParse(value.trim());
                                    if (port == null ||
                                        port <= 0 ||
                                        port > 65535) {
                                      return 'Puerto inválido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _webSocketPathController,
                            enabled: !widget.connecting,
                            decoration: const InputDecoration(
                              labelText: 'Ruta WebSocket',
                              hintText: '/',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _clientIdController,
                            enabled: !widget.connecting,
                            decoration: const InputDecoration(
                              labelText: 'Client ID',
                              hintText: 'light-controller-app',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Ingresa un client ID';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _usernameController,
                                  enabled: !widget.connecting,
                                  decoration: const InputDecoration(
                                    labelText: 'Usuario',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _passwordController,
                                  enabled: !widget.connecting,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Contraseña',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            value: _useTls,
                            onChanged: widget.connecting
                                ? null
                                : (value) {
                                    setState(() {
                                      _useTls = value;
                                    });
                                  },
                            title: const Text('Usar TLS/SSL'),
                            subtitle: const Text(
                              'Útil para brokers públicos o entornos de producción.',
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: widget.connecting ? null : _submit,
                    icon: widget.connecting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.wifi_tethering),
                    label:
                        Text(widget.connecting ? 'Conectando...' : 'Conectar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LightControllerView extends StatelessWidget {
  final BrokerConfig config;
  final Future<void> Function() onDisconnect;

  const LightControllerView({
    super.key,
    required this.config,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          config.useWebSocket
              ? 'Conectado por WebSocket'
              : 'Conectado por MQTT TCP',
        ),
        actions: [
          TextButton.icon(
            onPressed: onDisconnect,
            icon: const Icon(Icons.logout),
            label: const Text('Cambiar broker'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<IotLightBloc, AppState>(
              builder: (context, state) {
                final h1 = Theme.of(context).textTheme.displayLarge;
                final statusLabel = switch (state.connection) {
                  ConnectionStatus.connected => 'Conectado',
                  ConnectionStatus.connecting => 'Conectando',
                  ConnectionStatus.disconnected => 'Desconectado',
                };

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Broker actual',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Host: ${config.host}'),
                            Text('MQTT TCP: ${config.tcpPort}'),
                            Text(
                                'WebSocket: ${config.websocketPort}${config.websocketPath}'),
                            Text('Transporte: ${config.transport.label}'),
                            Text('TLS: ${config.useTls ? 'Sí' : 'No'}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      switch (state.light) {
                        LightStatus.on => '💡',
                        LightStatus.off => '🌃',
                        LightStatus.unknown => '🤔',
                      },
                      style: h1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Estado: $statusLabel',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Switch(
                        value: state.light == LightStatus.on,
                        onChanged: state.connection ==
                                ConnectionStatus.connected
                            ? (value) {
                                context.read<IotLightBloc>().switchLight(value);
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.connection != ConnectionStatus.connected
                          ? 'Esperando conexión con el broker...'
                          : state.light == LightStatus.unknown
                              ? 'Conectado al broker. Aún no llega estado del dispositivo.'
                              : 'Comando enviado y estado de luz actualizado.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

#include <Arduino.h>
#include <WiFi.h>
#include <PubSubClient.h>

#define USE_SSL_TLS 1

#if USE_SSL_TLS
#include <WiFiClientSecure.h>
WiFiClientSecure netClient;
#else
WiFiClient netClient;
#endif

PubSubClient mqttClient(netClient);

const char* WIFI_SSID = "Funcionarios";
const char* WIFI_PASSWORD = "SomosSena_2025";

const char* MQTT_BROKER = "be185510.ala.us-east-1.emqxsl.com";
const uint16_t MQTT_PORT = 8883;
const char* MQTT_USER = "Nexus";
const char* MQTT_PASSWORD = "Nexus1234@";

const char* MQTT_TOPIC_CONTROL = "nexusled/led/control";
const char* MQTT_TOPIC_STATUS = "nexusled/led/status";
const char* MQTT_TOPIC_COLOR = "nexusled/led/color";
const char* MQTT_TOPIC_HEARTBEAT = "nexusled/heartbeat";

const char* MQTT_CLIENT_ID_PREFIX = "nexusled_nano_esp32";
const uint16_t MQTT_KEEPALIVE_SECONDS = 60;
const uint32_t WIFI_RETRY_INTERVAL_MS = 10000;
const uint32_t MQTT_RETRY_INTERVAL_MS = 5000;
const uint32_t HEARTBEAT_INTERVAL_MS = 60000;

const uint8_t LED_PIN = LED_BUILTIN;
const uint8_t RED_PIN = D3;
const uint8_t GREEN_PIN = D5;
const uint8_t BLUE_PIN = D7;

bool ledState = false;
String currentColor = "white";
unsigned long lastWiFiRetry = 0;
unsigned long lastMqttRetry = 0;
unsigned long lastHeartbeat = 0;
String deviceId;

String buildClientId() {
  char buffer[64];
  const uint64_t mac = ESP.getEfuseMac();
  snprintf(
    buffer,
    sizeof(buffer),
    "%s-%04X%08X",
    MQTT_CLIENT_ID_PREFIX,
    static_cast<uint16_t>(mac >> 32),
    static_cast<uint32_t>(mac)
  );
  return String(buffer);
}

void publishState(bool retainMessage = true) {
  const char* stateText = ledState ? "ON" : "OFF";
  mqttClient.publish(MQTT_TOPIC_STATUS, stateText, retainMessage);
}

void publishHeartbeat() {
  mqttClient.publish(MQTT_TOPIC_HEARTBEAT, "ONLINE", false);
}

void setLed(bool on, bool notifyBroker = true) {
  ledState = on;
  digitalWrite(LED_PIN, on ? HIGH : LOW);
  Serial.printf("LED -> %s\n", on ? "ON" : "OFF");

  if (notifyBroker && mqttClient.connected()) {
    publishState(true);
  }
}

void setRgbColor(String color, bool notifyBroker = true) {
  currentColor = color;
  color.toLowerCase();

  // Apagar todos los pines primero
  digitalWrite(RED_PIN, LOW);
  digitalWrite(GREEN_PIN, LOW);
  digitalWrite(BLUE_PIN, LOW);

  // Encender solo el pin correspondiente al color (si no es "off")
  if (color == "red") {
    digitalWrite(RED_PIN, HIGH);
  } else if (color == "green") {
    digitalWrite(GREEN_PIN, HIGH);
  } else if (color == "blue") {
    digitalWrite(BLUE_PIN, HIGH);
  }
  // Si es "off", todos los pines ya están apagados

  Serial.printf("RGB Color -> %s\n", color.c_str());

  if (notifyBroker && mqttClient.connected()) {
    mqttClient.publish(MQTT_TOPIC_COLOR, color.c_str(), true);
  }
}

void handleCommand(const String& command) {
  String normalized = command;
  normalized.trim();
  normalized.toUpperCase();

  if (normalized == "ON" || normalized == "1" || normalized == "TRUE") {
    setLed(true);
  } else if (normalized == "OFF" || normalized == "0" || normalized == "FALSE") {
    setLed(false);
  } else if (normalized == "TOGGLE") {
    setLed(!ledState);
  } else if (normalized == "STATUS") {
    publishState(true);
  }
}

void onMqttMessage(char* topic, byte* payload, unsigned int length) {
  String topicName = String(topic);
  String message;
  message.reserve(length);

  for (unsigned int i = 0; i < length; i++) {
    message += static_cast<char>(payload[i]);
  }

  Serial.printf("MQTT [%s] %s\n", topicName.c_str(), message.c_str());

  if (topicName == MQTT_TOPIC_CONTROL) {
    handleCommand(message);
  } else if (topicName == MQTT_TOPIC_COLOR) {
    String color = message;
    color.toLowerCase();
    if (color == "red" || color == "green" || color == "blue" || color == "off") {
      setRgbColor(color);
    }
  }
}

bool connectWiFi() {
  if (WiFi.status() == WL_CONNECTED) {
    return true;
  }

  Serial.printf("Conectando a WiFi: %s\n", WIFI_SSID);
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);
  WiFi.setAutoReconnect(true);
  WiFi.disconnect(true);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  unsigned long start = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - start < 20000) {
    delay(500);
    Serial.print('.');
  }
  Serial.println();

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("WiFi conectado");
    Serial.print("IP: ");
    Serial.println(WiFi.localIP());
    return true;
  }

  Serial.println("No se pudo conectar al WiFi");
  return false;
}

bool connectMqtt() {
  if (WiFi.status() != WL_CONNECTED) {
    return false;
  }

#if USE_SSL_TLS
  netClient.setInsecure();
#endif

  mqttClient.setServer(MQTT_BROKER, MQTT_PORT);
  mqttClient.setCallback(onMqttMessage);
  mqttClient.setKeepAlive(MQTT_KEEPALIVE_SECONDS);
  mqttClient.setSocketTimeout(15);
  mqttClient.setBufferSize(256);

  const char* clientId = deviceId.c_str();

  bool connected = false;
  if (MQTT_USER[0] != '\0') {
    connected = mqttClient.connect(
      clientId,
      MQTT_USER,
      MQTT_PASSWORD,
      MQTT_TOPIC_STATUS,
      1,
      true,
      "OFFLINE"
    );
  } else {
    connected = mqttClient.connect(
      clientId,
      MQTT_TOPIC_STATUS,
      1,
      true,
      "OFFLINE"
    );
  }

  if (!connected) {
    Serial.printf("Fallo MQTT: %d\n", mqttClient.state());
    return false;
  }

  mqttClient.subscribe(MQTT_TOPIC_CONTROL, 1);
  mqttClient.subscribe(MQTT_TOPIC_COLOR, 1);
  
  // Asegurar que todos los LEDs estén apagados después de conectar
  digitalWrite(RED_PIN, LOW);
  digitalWrite(GREEN_PIN, LOW);
  digitalWrite(BLUE_PIN, LOW);
  currentColor = "off";
  
  publishState(true);
  publishHeartbeat();

  Serial.println("MQTT conectado y suscrito al tópico de control");
  return true;
}

void ensureConnections() {
  if (WiFi.status() != WL_CONNECTED) {
    if (millis() - lastWiFiRetry >= WIFI_RETRY_INTERVAL_MS) {
      lastWiFiRetry = millis();
      connectWiFi();
    }
    return;
  }

  if (!mqttClient.connected()) {
    if (millis() - lastMqttRetry >= MQTT_RETRY_INTERVAL_MS) {
      lastMqttRetry = millis();
      connectMqtt();
    }
    return;
  }

  mqttClient.loop();

  if (millis() - lastHeartbeat >= HEARTBEAT_INTERVAL_MS) {
    lastHeartbeat = millis();
    publishHeartbeat();
    // No publicar estado en heartbeat para evitar conflictos
  }
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  pinMode(LED_PIN, OUTPUT);
  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(BLUE_PIN, OUTPUT);
  
  // Inicializar todos los LEDs apagados explícitamente
  digitalWrite(LED_PIN, LOW);
  digitalWrite(RED_PIN, LOW);
  digitalWrite(GREEN_PIN, LOW);
  digitalWrite(BLUE_PIN, LOW);
  ledState = false;
  currentColor = "white";

  deviceId = buildClientId();
  Serial.println();
  Serial.println("============================");
  Serial.println(" NexusLED Nano ESP32 Sketch ");
  Serial.println("============================");
  Serial.print("Client ID: ");
  Serial.println(deviceId);

  connectWiFi();
  connectMqtt();
}

void loop() {
  ensureConnections();
}

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

// --- CONFIGURACIÓN ---
const char* WIFI_SSID = "Wokwi-GUEST";
const char* WIFI_PASSWORD = "";

const char* MQTT_BROKER = "be185510.ala.us-east-1.emqxsl.com";
const uint16_t MQTT_PORT = 8883;
const char* MQTT_USER = "Nexus";
const char* MQTT_PASSWORD = "Nexus1234@";

const char* MQTT_TOPIC_CONTROL = "nexusled/led/control";
const char* MQTT_TOPIC_STATUS = "nexusled/led/status";
const char* MQTT_TOPIC_COLOR = "nexusled/led/color";
const char* MQTT_TOPIC_HEARTBEAT = "nexusled/heartbeat";

const uint8_t LED_PIN = LED_BUILTIN;
const uint8_t RED_PIN = D3;
const uint8_t GREEN_PIN = D5;
const uint8_t BLUE_PIN = D7;

const uint8_t RGB_ON = LOW;
const uint8_t RGB_OFF = HIGH;

bool ledState = false;
unsigned long lastHeartbeat = 0;
const uint32_t HEARTBEAT_INTERVAL_MS = 60000;

// --- FUNCIONES CORE ---
void publishState() {
  mqttClient.publish(MQTT_TOPIC_STATUS, ledState ? "ON" : "OFF", true);
}

void publishHeartbeat() {
  mqttClient.publish(MQTT_TOPIC_HEARTBEAT, "ONLINE", false);
}

void setRgbColor(String color) {
  digitalWrite(RED_PIN, RGB_OFF);
  digitalWrite(GREEN_PIN, RGB_OFF);
  digitalWrite(BLUE_PIN, RGB_OFF);

  if (color == "red") digitalWrite(RED_PIN, RGB_ON);
  else if (color == "green") digitalWrite(GREEN_PIN, RGB_ON);
  else if (color == "blue") digitalWrite(BLUE_PIN, RGB_ON);
  
  Serial.println("Color aplicado: " + color);
}

void onMqttMessage(char* topic, byte* payload, unsigned int length) {
  String topicName = String(topic);
  String message = "";
  for (unsigned int i = 0; i < length; i++) message += (char)payload[i];
  message.trim();
  message.toLowerCase();

  Serial.printf("MQTT [%s] %s\n", topicName.c_str(), message.c_str());

  if (topicName == MQTT_TOPIC_CONTROL) {
    if (message == "on" || message == "1") ledState = true;
    else if (message == "off" || message == "0") ledState = false;
    digitalWrite(LED_PIN, ledState ? HIGH : LOW);
    publishState();
  } 
  else if (topicName == MQTT_TOPIC_COLOR) {
    setRgbColor(message);
    // IMPORTANTE: Eliminamos el publish aquí para no causar bucles infinitos
  }
}

void connectWiFi() {
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) delay(500);
  Serial.println("WiFi Conectado");
}

void connectMqtt() {
  netClient.setInsecure();
  mqttClient.setServer(MQTT_BROKER, MQTT_PORT);
  mqttClient.setCallback(onMqttMessage);
  
  if (mqttClient.connect("nexusled_nano_esp32", MQTT_USER, MQTT_PASSWORD, MQTT_TOPIC_STATUS, 1, true, "OFFLINE")) {
    mqttClient.subscribe(MQTT_TOPIC_CONTROL);
    mqttClient.subscribe(MQTT_TOPIC_COLOR);
    publishState();
    publishHeartbeat();
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(BLUE_PIN, OUTPUT);
  
  digitalWrite(RED_PIN, RGB_OFF);
  digitalWrite(GREEN_PIN, RGB_OFF);
  digitalWrite(BLUE_PIN, RGB_OFF);

  connectWiFi();
  connectMqtt();
}

void loop() {
  if (!mqttClient.connected()) connectMqtt();
  mqttClient.loop();

  if (millis() - lastHeartbeat >= HEARTBEAT_INTERVAL_MS) {
    lastHeartbeat = millis();
    publishHeartbeat();
  }
}
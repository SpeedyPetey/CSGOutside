#include <ESP8266WiFi.h>
int incomingByte = 0;
// Replace with your network credentials
const char* ssid = "SpeedyPetey";
const char* password = "peteriscool";

// Replace with the IP address of your server
const char* server_address = "192.168.43.134"; 
const int server_port = 8000;

void setup() {
  Serial.begin(9600);
  Serial1.begin(115200);
  delay(10);
  
  // Connect to Wi-Fi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected"); 
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  WiFiClient client;
  if (!client.connect(server_address, server_port)) {
    Serial.println("Connection failed");
    return;
  }
  // Create the JSON data to send
  //String tx_data = Serial1.readString();
  String rx_data = Serial.readString();
  Serial.println(rx_data);

  // Create the JSON data to send
  String json_data = "{\"name\": \"John\", \"rx\": \"" + rx_data + "\"}";

  

  // Connect to server


  // Send HTTP POST request
  String url = "/"; // Change this to match your server's URL
  String post_request = "POST " + url + " HTTP/1.1\r\n" +
                        "Host: " + server_address + "\r\n" +
                        "Content-Type: application/json\r\n" +
                        "Content-Length: " + String(json_data.length()) + "\r\n\r\n" +
                        json_data;
  client.print(post_request);

//  // Wait for response
//  while (client.connected()) {
//    if (client.available()) {
//      String line = client.readStringUntil('\r');
//      Serial.print(line);
//    }
//  }

//  // Close connection
//  client.stop();
//
//  // Wait for 5 seconds before sending another request
//  delay(5000);
}

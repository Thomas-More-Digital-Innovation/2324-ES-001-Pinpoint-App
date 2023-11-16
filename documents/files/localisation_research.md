# Methods regarding Localization

## 1. Outdoors Localization
### 1.1 Google Maps Platform
The Google Maps Platform utilizes a pay-per-request model, charging $5 USD for every 1000 requests. Additionally, it provides a monthly free use limit of $200 USD and integrates seamlessly with Google Maps.

### 1.2 Android Google Play API
The Android Google Play API offers free phone localization services exclusively for Android devices. It relies on the user's own device for localization and provides an accuracy range of 50 meters to a few meters.

### 1.3 IOS Core Location
The IOS Core Location service is available at no cost, catering specifically to IOS devices. It determines the position of one's IOS Core in relation to nearby devices using iBeacon.

### 1.4 Flutter Location 5.0.3 Dependency
The Flutter Location 5.0.3 Dependency is a free option supporting both IOS and Android platforms. It allows users to adjust the accuracy of phone localization as needed and includes a permission dialogue for added functionality.

### 1.5 Flutter geolocator: ^10.1.0 Dependency
Flutter geolocator: ^10.1.0 Dependency is a cross-platform solution for localization, it is able to calculate current location save last location and calculate distance in meters between two coordinates. It uses IOS core Location and Android Google Play to determine a devices location.
 
### 1.5 Cross-platform compatability
Because we want the app to be available in both the google play store and Apple store, it needs to be compatible with both Android and IOS. The Google play API is only available for Android and IOS Core Location is only available for IOS, therefore these methods would slow development speed. Google maps Platform seems to be a good option, a lot of documentation, by google same as flutter, but they charge $5USD per 1000 requests with $200USD free credit every month. Both flutter dependencies IOS and Android, these methods are also free making it the best option in my opinion.

### 1.6 Pricing
There is no funding at this moment so a free option is required. While Google Maps Platform has a monthly free credit of $200USD, I would prefer a completely free option, avoiding the possibility of billing. This leaves "Flutter Location 5.0.3 Dependency" and "Flutter geolocator: ^10.1.0 Dependency" which are completely free.

## 2. Indoors Localization
### 2.1 Bluetooth Low Energy (BLE)
BLE utilizes RSSI to determine distance and approximate location. iBeacon, compatible with IOS devices, can trigger actions when in proximity. Eddystone can send a URL to all Bluetooth-enabled devices nearby. This technology allows for precise location down to the centimeter, supports direction finding, and requires the use of beacons. A Flutter plugin, flutter_blue_plus, facilitates BLE integration in Flutter applications.

### 2.2 WiFi
This methods makes use of the connection to wireless access points and hotspots to determine the location of the device. It has a lower accuracy that is around 3-5 meters. Apparently Apple has forbidden the use of API's for indoor localisation using WiFi.

### 2.3 Ultra Wide Band (UWB)
In UWB there are 3 main Algorithms, 

### 2.4 Inertial Sensors
Using inertial sensors of a phone and using a dead-reckoning mechanism we can calculate the position of a user. This needs recalibration because it calculates the position of users from a start position and calculates further location using the inertial sensors of the phone. That is why overtime this location will become inaccurate and needs callibration.

# Conclusion
- For localisation outdoors, I suggest "Flutter Location 5.0.3 Dependency" or "Flutter geolocator: ^10.1.0 Dependency" as the best options to use when using flutter, mainly due to the versitality of these dependencies. There both cross-platform compatible. Personaly I feel like "Flutter geolocator: ^10.1.0 Dependency" is better described and has more flexebility than "Flutter Location 5.0.3 Dependency", this is why I suggest we use this dependency. Because we might want an integration with google maps we need to keep an eye on Google Maps platform. While this is not free, it seems to be the best way to integrate google maps in our app.

- For localisation indoors, further research is needed. While BLE looks like a good option, the event would need to make the commitment of buying beacons for this to work.
# Google Maps Platform
The Google Maps Platform utilizes a pay-per-request model, charging $5 USD for every 1000 requests. Additionally, it provides a monthly free use limit of $200 USD and integrates seamlessly with Google Maps.

# Android Google Play API
The Android Google Play API offers free phone localization services exclusively for Android devices. It relies on the user's own device for localization and provides an accuracy range of 50 meters to a few meters.

# IOS Core Location
The IOS Core Location service is available at no cost, catering specifically to IOS devices. It depends on the user's own IOS device for localization and extends to other IOS devices.

# Flutter Location 5.0.3 Dependency
The Flutter Location 5.0.3 Dependency is a free option supporting both IOS and Android platforms. It allows users to adjust the accuracy of phone localization as needed and includes a permission dialogue for added functionality.

BLE utilizes RSSI to determine distance and approximate location. iBeacon, compatible with IOS devices, can trigger actions when in proximity. Eddystone can send a URL to all Bluetooth-enabled devices nearby. This technology allows for precise location down to the centimeter, supports direction finding, and requires the use of beacons. A Flutter plugin, flutter_blue_plus, facilitates BLE integration in Flutter applications.

# Conclusion
- For localisation outdoors, I suggest " Flutter Location 5.0.3 Dependency " as the best option to use when using flutter, mainly due to the versitality of this library. It is a flutter library that supports both IOS and Android. Because we might want an integration with google maps we need to keep an eye on Google Maps platform. While this is not free, it seems to be the best way to integrate google maps in our app.

- For localisation indoors, further research is needed. While BLE looks like a good option, the event would need to make the commitment of buying beacons for this to work.
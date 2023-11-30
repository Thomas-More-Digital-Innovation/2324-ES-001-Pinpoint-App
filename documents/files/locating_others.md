# Locating other people
One of the key features of our app is the ability to not only track your own location but also to conveniently locate your friends. This feature enhances the social aspect of the application, allowing users to stay connected and informed about the whereabouts of their friends.

## How it works
### Saving location data
To be able to get the location of a user, the app utilizes the device's geolocation services through the flutter `geolocator` package. When a user grants permission, the app captures the current location of the device periodically and stores this information.

### User Profiles
Every user has it's own profile that saves information about the user and also their location. This profile is updated regularly so that the location is accurate and resembles a real-time tracking.

### Fetching Friend's Location
When a user wishes to locate a friend, they simply access their friend's profile within the app. The location information is then extracted from the friend's profile, providing a seamless and user-friendly experience.

## Conclusion
Through the association of location data with user profiles, we offer a user-friendly method for friends to stay connected and exchange their locations. 
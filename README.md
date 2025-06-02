# CourierFlow Mobile Delivery Application

CourierFlow is a robust, feature-rich mobile application designed for couriers and delivery personnel to streamline package deliveries with optimized routes, real-time tracking, and digital package management.

## 📱 Features

### Authentication
- Secure JWT token-based authentication
- User credentials management with local secure storage
- Clean, intuitive login interface

### QR Code Package Scanning
- High-performance QR code scanning for package tracking
- Real-time package validation against backend
- Swipe-up panel showing scanned locations

### Intelligent Route Navigation
- GPX data visualization with optimized routes using Dijkstra's algorithm
- Turn-by-turn navigation with distance calculations
- Real-time location tracking
- Custom map markers for delivery points

### User Profile Management
- Profile information display
- Delivery history tracking
- Performance statistics

### Offline Capability
- Local data storage for continuous operation in low-connectivity areas
- Automatic synchronization when connectivity is restored

## 📸 Screenshots

### Login Screen
![Login Screen](https://raw.githubusercontent.com/vrtkarim/courierflowapp/refs/heads/main/login.jpg)

The login screen features a clean, modern interface with the CourierFlow logo. It provides fields for username and password entry, along with secure authentication through JWT tokens that are stored locally for persistent sessions.

### Package Scanning
![Scanning Page](https://raw.githubusercontent.com/vrtkarim/courierflowapp/refs/heads/main/scanning.jpg)

The scanning interface incorporates a real-time camera feed with QR code detection overlay. The bottom panel displays previously scanned packages and can be expanded with a swipe-up gesture. The app bar includes the courier's profile image for quick access to user information.

### Courier Profile
![Courier Profile](https://raw.githubusercontent.com/vrtkarim/courierflowapp/refs/heads/main/profile.jpg)

The profile page provides comprehensive information about the courier, including performance metrics, delivery history, and personal details. This screen allows couriers to track their efficiency and manage their account settings.

### Optimized Route Map
![Map Navigation](https://raw.githubusercontent.com/vrtkarim/courierflowapp/refs/heads/main/map.jpg)

The navigation map displays the courier's current location (represented by the delivery vehicle icon) and upcoming delivery points (package icons). The optimized route is calculated using Dijkstra's algorithm for the most efficient path between multiple stops, highlighted with a distinctive orange line. A floating action button allows quick re-centering on the current location.

## 🔧 Technical Architecture

### Frontend
- **Framework**: Flutter for cross-platform compatibility
- **State Management**: BLoC pattern for predictable state changes
- **Map Visualization**: Flutter Map with OpenStreetMap integration
- **Scanning**: Mobile Scanner package with custom overlay

### Backend Integration
- **API Communication**: RESTful API interaction with Spring Boot backend
- **Authentication**: JWT token handling with secure storage
- **Data Format**: GPX for route data, JSON for API responses

### Location Services
- Real-time GPS tracking with Geolocator package
- Custom map markers for improved visibility
- Route visualization with polylines

## 📋 Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/courierflow.git
   ```

2. Navigate to the project directory:
   ```
   cd courierflow
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app in debug mode:
   ```
   flutter run
   ```

## 🚀 Deployment

### Android
1. Build the release APK:
   ```
   flutter build apk --release
   ```

2. The APK will be available at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

### iOS
1. Build the release IPA:
   ```
   flutter build ios --release
   ```

2. Use Xcode to archive and distribute the app.

## 📊 Future Enhancements

- **Real-time Analytics**: Detailed delivery performance metrics
- **Multi-language Support**: Localization for international use
- **Voice Guidance**: Turn-by-turn voice navigation
- **Batch Scanning**: Multiple package scanning capability
- **Customer Signature Collection**: Digital proof of delivery

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.



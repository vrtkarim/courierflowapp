# CourierFlow Mobile Delivery Application

check the backend made using spring  boot : repo : https://https://github.com/vrtkarim/courierflow


## 📸 Screenshots

### Login Screen
<p align="center">
  <img src="https://raw.githubusercontent.com/vrtkarim/courierflowapp/refs/heads/main/login.jpg" width="300" alt="Login Screen">
</p>

The login screen features a clean, modern interface with the CourierFlow logo. It provides fields for username and password entry, along with secure authentication through JWT tokens that are stored locally for persistent sessions.

### Package Scanning
<p align="center">
  <img src="https://raw.githubusercontent.com/vrtkarim/courierflowapp/refs/heads/main/scanning.jpg" width="300" alt="Scanning Page">
</p>

The scanning interface incorporates a real-time camera feed with QR code detection overlay. The bottom panel displays previously scanned packages and can be expanded with a swipe-up gesture. The app bar includes the courier's profile image for quick access to user information.

### Courier Profile
<p align="center">
  <img src="https://raw.githubusercontent.com/vrtkarim/courierflowapp/refs/heads/main/profile.jpg" width="300" alt="Courier Profile">
</p>

The profile page provides comprehensive information about the courier, including performance metrics, delivery history, and personal details. This screen allows couriers to track their efficiency and manage their account settings.

### Optimized Route Map
<p align="center">
  <img src="https://raw.githubusercontent.com/vrtkarim/courierflowapp/refs/heads/main/map.jpg" width="300" alt="Map Navigation">
</p>

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



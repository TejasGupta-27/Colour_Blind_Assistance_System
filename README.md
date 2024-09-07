# Colour_Blind_Assistance_System


The Color Blindness Simulator App is a Flutter-based mobile application that allows individuals with color blindness perceive images. It includes features like choosing photos from the gallery or taking photos using the camera,and classify the image provided and also give the colour of the object.

## Modules

### 1. Welcome Screen

- **Location:** lib/welcome_screen.dart
- **Description:** The Welcome Screen is the initial screen that users see when they open the app. It includes a colorful circular loader, a welcome message, and a "Sign In with Google" button to facilitate Google Sign-In.

### 2. Home Page

- **Location:** lib/home_page.dart
- **Description:** The Home Page is the main screen of the app. It provides options for users to choose photos from the gallery or take photos using the camera. The selected images can be displayed with color correction.

### 3. Authentication Service

- **Location:** lib/auth_service.dart
- **Description:** The Authentication Service handles user authentication using Firebase Authentication. It includes methods for Google Sign-In, fetching the current user, and signing out.

### 4. Firebase Integration

- **Location:** lib/firebase_integration.dart
- **Description:** This module contains code related to the integration of Firebase services, including Firebase Authentication. It includes configurations and initialization for Firebase.

### 5. API Integration

- **Location:** lib/api.dart
- **Description:** The API Integration module handles communication with the backend. It includes methods for sending and receiving data related to user details and color blindness information.

### 6. Python Computer Vision
Google Ml kit used
## Getting Started

### Prerequisites

- Install Flutter: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Set up Firebase: [Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)

### Running the App

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo

### Dependencies

Firebase: Firebase services for authentication.
Image Picker: Flutter plugin for picking images from the gallery or camera.
Add other relevant dependencies...

### Contributing

Contributions are welcome! Please follow the Contributing Guidelines.

### License

This project is licensed under the MIT License.   

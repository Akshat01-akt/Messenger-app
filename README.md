# Flutter Chat App

A modern, full-featured chat application built with Flutter and Firebase. This app provides real-time messaging, media sharing, and a seamless user experience with both light and dark mode support.

## 🚀 Features

-   **Real-time Messaging**: Instant messaging powered by Cloud Firestore.
-   **Secure Authentication**: User sign-up and login using Firebase Authentication.
-   **Media Sharing**: Send and receive images securely with Firebase Storage.
-   **Contact Management**: meaningful interactions with your contacts.
-   **Call History**: Keep track of your incoming, outgoing, and missed calls.
-   **Theme Support**: Beautiful UI with full support for Light and Dark modes.
-   **State Management**: efficient state management using GetX and Bloc.

## 🛠️ Tech Stack

-   **Frontend**: Flutter (Dart)
-   **Backend**: Firebase (Auth, Firestore, Storage)
-   **State Management**: GetX, Flutter Bloc
-   **Dependency Injection**: GetIt
-   **Routing**: GetX Navigation

## 📂 Project Structure

-   `lib/data`: Data layer containing models and services (Firebase, Repositories).
-   `lib/presentation`: UI layer organized by features (Auth, Home, Chat, Profile).
-   `lib/logic` & `lib/core`: Business logic and core utilities.
-   `lib/config`: App configuration and themes.

## 🏁 Getting Started

### Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
-   [Firebase](https://firebase.google.com/) project set up.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/chat-app.git
    cd chat-app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Configuration:**
    -   Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective directories.

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

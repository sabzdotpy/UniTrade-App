![alt](./assets/icons/apple-76x76.png)
# UniTrade

UniTrade is a centralized marketplace tailored for university students, offering affordable, high-quality electronic components while fostering a trusted and accountable community. By restricting access to verified university members, UniTrade ensures a secure environment for peer-to-peer transactions, minimizing delays and enhancing efficiency. Beyond its commercial role, UniTrade promotes sustainability, innovation, and collaboration within the academic ecosystem.

## Key Features
- **Affordable Components**: Access to high-quality electronic components at student-friendly prices.
- **Trusted Community**: Restricted to verified university members for secure transactions.
- **Efficient Transactions**: Peer-to-peer exchanges to minimize delays.
- **Sustainability**: Encourages reuse of underutilized resources.
- **Collaboration**: Connects like-minded individuals for projects and innovation.

## Folder Structure
```
UniTrade Backup/
├── android/                # Android-specific files
├── assets/                 # Icons, images, and mockups
├── build/                  # Generated build files
├── ios/                    # iOS-specific files
├── lib/                    # Main Dart codebase
│   ├── firebase_options.dart
│   ├── main.dart
│   ├── pages/              # App pages
│   └── utils/              # Utility functions
├── linux/                  # Linux-specific files
├── macos/                  # macOS-specific files
├── test/                   # Test files
├── web/                    # Web-specific files
├── windows/                # Windows-specific files
├── analysis_options.yaml   # Linter rules
├── firebase.json           # Firebase configuration
├── key.properties          # Key properties for Android
├── pubspec.yaml            # Dart dependencies
└── README.md               # Project documentation
```

## Development Notes
- **Flutter SDK**: Ensure Flutter SDK is installed and configured.
- **Dependencies**: Run `flutter pub get` to install dependencies.
- **Firebase Setup**: Add your Firebase configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).
- **Environment Variables**: Use `flutter_dotenv` for managing environment variables.
- **Testing**: Use the `test` directory for widget and unit tests.

## Getting Started
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd UniTrade
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Contribution
Contributions are welcome! Please fork the repository and submit a pull request for review.
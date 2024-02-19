# MovieSearch iOS Project

## Getting Started

Follow these steps to set up the project on your local machine for development and testing purposes.

### Prerequisites

- Minimum iOS version support: iOS 15

### Installation

1. Open the project in Xcode by double-clicking on the `MovieSearch.xcodeproj` file.

2. Configuration File Setup:
    1. Find the `Config.plist.example` file in the project directory.
    2. Copy `Config.plist.example` to `Config.plist` within the same directory.
    3. To use the application, you must obtain an API key from TMDB:
        1. Visit the TMDB website and create an account or log in.
        2. Navigate to the API section and follow the instructions to request an API key.
        3. Once you have your API key, open `Config.plist` and replace `TMDBAPIKey` with your own API key.
3. Build and run the application in Xcode to start using App.

## Note
This app relies on the TMDB API for movie data. Ensure your API key remains confidential to prevent unauthorized access and potential misuse.


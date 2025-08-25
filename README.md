# Sklad

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org/)
[![Platform](https://img.shields.io/badge/Platform-iOS_15.0+-blue.svg)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-MVC-brightgreen.svg)](https://developer.apple.com/documentation/swiftui/state-and-data-flow)

 iOS application for a warehouse management system, designed to digitize logistics processes within a division of the company "Savushkin Product."


  The application enables tracking of the receipt, movement, and write-off of materials, preventing losses and ensuring full transparency of operations.
 
| Main Screen | Details Screen | Write-off Screen |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/3178784c-feb5-4590-bcef-6a5b3e80b0fd" width="250"> | <img src="https://github.com/user-attachments/assets/fca46de0-dee0-4a42-b417-75329a802b56" width="250"> | <img src="https://github.com/user-attachments/assets/076959f6-6847-47b0-9c1e-cc01e2e8ba21" width="250"> |
🚀 Features

🔐 User Authentication via login and password.

📦 Inventory Management: Adding, editing, viewing, and writing off product items.

📷 Barcode Scanning: Integration with the device's camera for quick product search and accounting.

🌐 Real-time Operation: All changes are synchronized between devices.

📊 Operations History: Maintaining a log of all warehouse operations (receipt, write-off, transfer).

## Tech Stack

*   **UI Framework:** UIKit
*   **Architecture:** MVC (Model-View-Controller)
*   **Local Storage:** CoreData
*   **Networking:** REST API
*   **Concurrency:** async/await

## Implementation Details

The project is built using traditional Apple technologies:

*   **UIKit** for building the user interface with programmatic layout (without Storyboards)
*   **MVC** as the main architectural pattern
*   **CoreData** for local persistence and data management
*   **REST API** communication using native URLSession
*   **async/await** for handling asynchronous operations

## Installation

1. Clone the repository
2. Open `Sklad.xcodeproj`
3. Install dependencies (if any)
4. Build and run the project

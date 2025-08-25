# Sklad

iOS application for a warehouse management system, designed to digitize logistics processes within a division of the company "Savushkin Product."
 The application enables tracking of the receipt, movement, and write-off of materials, preventing losses and ensuring full transparency of operations.
 
<img width="117" height="253.2" alt="MainView" src="https://github.com/user-attachments/assets/3178784c-feb5-4590-bcef-6a5b3e80b0fd" />
<img width="117" height="253.2" alt="DetailsView" src="https://github.com/user-attachments/assets/fca46de0-dee0-4a42-b417-75329a802b56" />
<img width="117" height="253.2" alt="WriteOffView" src="https://github.com/user-attachments/assets/076959f6-6847-47b0-9c1e-cc01e2e8ba21" />

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

## Requirements

*   iOS 15.0+
*   Xcode 13.0+
*   Swift 5.5+

## Installation

1. Clone the repository
2. Open `Sklad.xcodeproj`
3. Install dependencies (if any)
4. Build and run the project

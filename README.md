# SNAPSHOOTER  <img src="https://github.com/user-attachments/assets/5ee57aa2-1446-46cb-9ab1-1e72afde1961" alt="SnapShooter Logo" align="center" width=128>



A lightweight and efficient library for snapshot testing UIViewController instances. This library allows you to capture and compare snapshots of your views, calculate their similarity, and highlight differences when they occur. It supports saving snapshots and difference images as attachments in test reports and storing them in the temporary folder for debugging purposes.

## Features

- 📸 Snapshot Testing: Capture precise snapshots of UIViewController views for testing purposes.
-	🔍 Similarity Comparison: Calculate the similarity between two snapshots using pixel-by-pixel analysis.
-	🎨 Difference Highlighting: Automatically highlight visual differences between snapshots for easy debugging.
-	📂 Save Snapshots and Highlights:
-	Attach difference images to test reports for CI/CD workflows.
-	Store snapshots and highlights in the temporary folder for detailed local analysis.
-	⚡ Seamless Integration: Works with XCTest for smooth integration into your test suite.

## Installation

Swift Package Manager (SPM)

Add the following dependency to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/mkemalgokce/SnapShooter", from: "1.0.0")
]
```

## Usage

### 1. Capturing a Snapshot

Use the snapshot() method to capture a snapshot of a UIViewController instance:

```swift
let viewController = MyViewController()
viewController.view.backgroundColor = .white
let snapshot = viewController.snapshot()
```

### 2. Recording a Snapshot

Save the snapshot to a file for future comparisons:

```swift
record(snapshot, file: #filePath, line: #line, function: #function)
```

### 3. Asserting Snapshot Similarity

Compare the current snapshot with a previously recorded one:

```swift
assert(snapshot, file: #filePath, line: #line, function: #function)
```

If the snapshots differ, the library:
  -	Highlights differences in a generated image.
  - Saves the difference image and new snapshot to the temporary folder.
  - Attaches the difference image to the test report.

## Contributing

Contributions are welcome! If you find a bug or want to suggest a feature, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

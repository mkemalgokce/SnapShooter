// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import XCTest

public extension XCTestCase {
    func assert(
        _ snapshot: UIImage,
        threshold similarityThreshold: Float = 0.98,
        file: StaticString = #filePath,
        line: UInt = #line,
        function: String = #function
    ) {
        let snapshotFolderURL = snapshotFolder(for: file)
        let name = makeSnapshotName(function: function)
        let storedSnapshotURL = snapshotFolderURL.appendingPathComponent("\(name).png")
        
        guard let storedSnapshot = loadStoredImage(from: storedSnapshotURL, file: file, line: line) else {
            record(snapshot, file: file, line: line, function: function)
            return
        }
        
        guard let similarity = try? snapshot.similarity(between: storedSnapshot) else {
            XCTFail("Failed to calculate snapshot difference", file: file, line: line)
            return
        }
        
        if similarity < similarityThreshold {
            let differenceImageURL = temporarySnapshotFolder(for: file).appendingPathComponent("Difference-\(name).png")
            let snapshotURL = temporarySnapshotFolder(for: file).appendingPathComponent("\(name).png")
            if let differenceImage = try? snapshot.highlightDifference(between: storedSnapshot) {
                saveTemporaryImage(image: differenceImage, on: differenceImageURL)
                attachTemporaryImage(image: differenceImage, name: "Difference")
            }
            
            attachTemporaryImage(image: snapshot, name: "New_Snapshot")
            saveTemporaryImage(
                image: snapshot,
                on: snapshotURL
            )
            
            XCTFail(
                """
                
                Sir, we have a problem! Snapshot failed with similarity: \(similarity) 🥶🥶
                
                Stored snapshot: \(storedSnapshotURL)
                
                Difference snapshot: \(differenceImageURL)
                
                New snapshot: \(snapshotURL)
                
                🤕 Please see attachments for more details. ⚠️
                
                
                ⬜🟥🟥🟥
                🟥🟥🟦🟦
                🟥🟥🟥🟥
                ⬜🟥🟥🟥
                ⬜🟥⬜🟥
                
                """,
                file: file,
                line: line
            )
        }
    }
    
    func record(_ snapshot: UIImage, file: StaticString = #filePath, line: UInt = #line, function: String = #function) {
        let snapshotFolderURL = snapshotFolder(for: file)
        let name = makeSnapshotName(function: function)
        let snapshotURL = snapshotFolderURL.appendingPathComponent("\(name).png")
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotFolderURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            try snapshot.pngData()?.write(to: snapshotURL)
        } catch {
            XCTFail("""
                    Sir, we have a problem! Failed to save snapshot at \(snapshotURL) 🥶🥶
                    That is the error: \(error) 
                    Be careful, Sir! ⚠️
                    """,
                    file: file,
                    line: line
            )
        }
    }
    
    // MARK: - Helpers
    private func loadStoredImage(from url: URL, file: StaticString = #filePath, line: UInt = #line) -> UIImage? {
        guard let storedSnapshotData = try? Data(contentsOf: url) else {
            return nil
        }
        guard let storedImage = UIImage(data: storedSnapshotData, scale: 3.0) else {
            return nil
        }
        return storedImage
    }
    
    private func snapshotFolder(for file: StaticString) -> URL {
        URL(fileURLWithPath: "\(file)")
            .deletingLastPathComponent()
            .appendingPathComponent("Snapshots")
    }
    
    private func temporarySnapshotFolder(for file: StaticString) -> URL {
        URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("Snapshots")
    }
    
    private func saveTemporaryImage(
        image: UIImage,
        on url: URL
    ) {
        let data = image.pngData()
        try? data?.write(to: url)
    }
    
    private func attachTemporaryImage(
        image: UIImage,
        name: String
    ) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name
        add(attachment)
    }
    
    private func makeSnapshotName(function: String) -> String {
        function
            .replacingOccurrences(of: "^test", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^_", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\(\\)", with: "", options: .regularExpression)
            .replacingOccurrences(of: " ", with: "_")
            .uppercased()
    }
    
}

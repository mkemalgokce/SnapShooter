// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import XCTest
import UIKit
@testable import SnapShooter

final class UIImageDiffTests: XCTestCase {
    func test_highlightDifference_WhenImagesAreDifferentSize_ThrowsImagesAreDifferentSizeError() {
        let image1 = UIImage(systemName: "star.fill")!
        let image2 = UIImage(systemName: "circle.fill")!
        
        XCTAssertThrowsError(try image1.highlightDifference(between: image2)) { error in
            XCTAssertEqual(error as? UIImage.Error, .imagesAreDifferentSize)
        }
    }
    
    func test_highlightDifference_WhenImagesAreDifferent_ReturnsHighlightedImage() throws {
        let size = CGSize(width: 10, height: 10)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image1 = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        let image2 = renderer.image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        let highlightedImage = try image1.highlightDifference(between: image2)
        
        XCTAssertNotNil(highlightedImage.cgImage)
    }
    
    func test_highlightDifference_whenImagesAreEmpty_throwsEmptyCGImageError() {
        let image1 = UIImage()
        let image2 = UIImage()
        
        XCTAssertThrowsError(try image1.highlightDifference(between: image2)) { error in
            XCTAssertEqual(error as? UIImage.Error, .emptyCGImage)
        }
    }
 }


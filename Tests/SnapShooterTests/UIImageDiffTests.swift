// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import XCTest
import UIKit
@testable import SnapShooter

final class UIImageDiffTests: XCTestCase {
    func testPixelBuffer_WhenCGImageIsNil_ThrowsEmptyCGImageError() {
        let image = UIImage()
        
        XCTAssertThrowsError(try image.pixelBuffer()) { error in
            XCTAssertEqual(error as? UIImage.Error, .emptyCGImage)
        }
    }
        
    func testPixelBuffer_WhenSuccessful_ReturnsValidPixelBuffer() throws {
        let size = CGSize(width: 10, height: 10)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        let pixelBuffer = try image.pixelBuffer()
        
        XCTAssertEqual(pixelBuffer.count, Int(size.width * size.height * 4) * 9) // 4 bytes per pixel
    }
    
    func testSimilarity_WhenImagesAreDifferentSize_ThrowsImagesAreDifferentSizeError() {
        let image1 = UIImage(systemName: "star.fill")!
        let image2 = UIImage(systemName: "circle.fill")!
        
        XCTAssertThrowsError(try image1.similarity(between: image2)) { error in
            XCTAssertEqual(error as? UIImage.Error, .imagesAreDifferentSize)
        }
    }
    
    func testSimilarity_WhenImagesAreIdentical_ReturnsMaximumSimilarity() throws {
        let size = CGSize(width: 10, height: 10)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        let similarity = try image.similarity(between: image)
        
        XCTAssertEqual(similarity, 1.0)
    }
    
    func testSimilarity_WhenImagesAreDifferent_ReturnsLowerSimilarity() throws {
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
        
        let similarity = try image1.similarity(between: image2)
        
        XCTAssertLessThan(similarity, 1.0)
    }
    
    func testHighlightDifference_WhenImagesAreDifferentSize_ThrowsImagesAreDifferentSizeError() {
        let image1 = UIImage(systemName: "star.fill")!
        let image2 = UIImage(systemName: "circle.fill")!
        
        XCTAssertThrowsError(try image1.highlightDifference(between: image2)) { error in
            XCTAssertEqual(error as? UIImage.Error, .imagesAreDifferentSize)
        }
    }
    
    func testHighlightDifference_WhenImagesAreDifferent_ReturnsHighlightedImage() throws {
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
        
        XCTAssertNotNil(highlightedImage.cgImage) // Ensure the image is generated
    }
    
    func test_highlightDifference_whenImagesAreEmpty_throwsEmptyCGImageError() {
        let image1 = UIImage()
        let image2 = UIImage()
        
        XCTAssertThrowsError(try image1.highlightDifference(between: image2)) { error in
            XCTAssertEqual(error as? UIImage.Error, .emptyCGImage)
        }
    }
 }


// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UIImage {
    enum Error: Swift.Error {
        case imagesAreDifferentSize
        case imageBuffersCouldNotBeCreated
        case emptyCGImage
    }
    
    func pixelBuffer() throws -> [UInt8] {
        guard let cgImage = cgImage else {
            throw Error.emptyCGImage
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast
        
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            throw Error.imageBuffersCouldNotBeCreated
        }
        
        context.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        return pixelData
    }
    
    
    func similarity(between other: UIImage) throws -> Float {
        guard size == other.size else {
            throw Error.imagesAreDifferentSize
        }
        
        guard let pixels = try? pixelBuffer(),
                let otherPixels = try? other.pixelBuffer() else {
                throw Error.imageBuffersCouldNotBeCreated
        }
        
        let similarity = compareAllPixels(
            pixelCount: pixels.count / 4,
            referencePixels: pixels,
            imagePixels: otherPixels
        )
        
        return similarity
    }
    
    func highlightDifference(between other: UIImage) throws -> UIImage {
        guard size == other.size else {
            throw Error.imagesAreDifferentSize
        }
        
        guard let cgImage, let otherCgImage = other.cgImage else {
            throw Error.emptyCGImage
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.translateBy(x: 0, y: size.height)
            cgContext.scaleBy(x: 1.0, y: -1.0)
            cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
            cgContext.setAlpha(0.5)
            cgContext.beginTransparencyLayer(auxiliaryInfo: nil)
            cgContext.draw(otherCgImage, in: CGRect(origin: .zero, size: size))
            cgContext.setBlendMode(.difference)
            cgContext.setFillColor(UIColor.white.cgColor)
            cgContext.fill(CGRect(origin: .zero, size: size))
            cgContext.endTransparencyLayer()
        }
        
    }
}

fileprivate func compareAllPixels(
    perPixelTolerance: CGFloat = 0,
    pixelCount: Int,
    referencePixels: [UInt8],
    imagePixels: [UInt8]
) -> Float {
    var numSimilarPixels = 0

    let bytesPerPixel = 4
    for n in stride(from: 0, to: pixelCount * bytesPerPixel, by: bytesPerPixel) {
        let rDiff = abs(Int(referencePixels[n]) - Int(imagePixels[n]))
        let gDiff = abs(Int(referencePixels[n + 1]) - Int(imagePixels[n + 1]))
        let bDiff = abs(Int(referencePixels[n + 2]) - Int(imagePixels[n + 2]))
        let aDiff = abs(Int(referencePixels[n + 3]) - Int(imagePixels[n + 3]))

        if rDiff <= Int(perPixelTolerance),
           gDiff <= Int(perPixelTolerance),
           bDiff <= Int(perPixelTolerance),
           aDiff <= Int(perPixelTolerance) {
            numSimilarPixels += 1
        }
    }

    return Float(numSimilarPixels) / Float(pixelCount)
}

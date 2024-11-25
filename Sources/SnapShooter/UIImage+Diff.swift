// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UIImage {
    enum Error: Swift.Error {
        case imagesAreDifferentSize
        case emptyCGImage
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

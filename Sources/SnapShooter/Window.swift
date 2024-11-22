// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public extension UIViewController {
    func snapshot(for configuration: Configuration = .iPhone13()) -> UIImage {
        let window = Window(configuration: configuration, vc: self)
        return window.snapshot()
    }
}

final class Window: UIWindow {
    private var configuration: Configuration = .iPhone13()
    
    convenience init(configuration: Configuration, vc: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        rootViewController = vc
        layoutMargins = configuration.layoutMargins
        vc.view.layoutMargins = configuration.layoutMargins
        isHidden = false
    }
    
    override var traitCollection: UITraitCollection {
        configuration.traitCollection
    }
    
    override var safeAreaInsets: UIEdgeInsets {
        configuration.safeAreaInsets
    }
    
    func snapshot() -> UIImage {
        let traitCollection = configuration.traitCollection
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}

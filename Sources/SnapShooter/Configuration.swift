// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public struct Configuration {
    public let size: CGSize
    public let safeAreaInsets: UIEdgeInsets
    public let layoutMargins: UIEdgeInsets
    public let traitCollection: UITraitCollection
    
    public init(size: CGSize, safeAreaInsets: UIEdgeInsets, layoutMargins: UIEdgeInsets, traitCollection: UITraitCollection) {
        self.size = size
        self.safeAreaInsets = safeAreaInsets
        self.layoutMargins = layoutMargins
        self.traitCollection = traitCollection
    }
    
    public static func iPhone13(style: UIUserInterfaceStyle = .light,
                         contentSize: UIContentSizeCategory = .medium) -> Self {
        Self(
            size: CGSize(width: 390, height: 844),
            safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
            traitCollection: .portraitPhone(style: style, contentSize: contentSize)
        )
    }

    public static func iPhoneSE(style: UIUserInterfaceStyle = .light,
                         contentSize: UIContentSizeCategory = .medium) -> Self {
        Self(
            size: CGSize(width: 375, height: 667),
            safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            layoutMargins: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
            traitCollection: .portraitPhone(style: style, contentSize: contentSize)
        )
    }
}

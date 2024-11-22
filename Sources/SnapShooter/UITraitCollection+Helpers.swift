// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UITraitCollection {
    convenience init(
        style: UIUserInterfaceStyle,
        displayScale: CGFloat,
        displayGamut: UIDisplayGamut,
        layoutDirection: UITraitEnvironmentLayoutDirection,
        contentSize: UIContentSizeCategory,
        userInterfaceIdiom: UIUserInterfaceIdiom,
        horizontalSizeClass: UIUserInterfaceSizeClass,
        verticalSizeClass: UIUserInterfaceSizeClass
    ) {
        let traits = [
            UITraitCollection(userInterfaceStyle: style),
            UITraitCollection(displayScale: displayScale),
            UITraitCollection(displayGamut: displayGamut),
            UITraitCollection(layoutDirection: layoutDirection),
            UITraitCollection(preferredContentSizeCategory: contentSize),
            UITraitCollection(userInterfaceIdiom: userInterfaceIdiom),
            UITraitCollection(horizontalSizeClass: horizontalSizeClass),
            UITraitCollection(verticalSizeClass: verticalSizeClass)
        ]
        
        self.init(traitsFrom: traits)
    }
    
    static func portraitPhone (style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory) -> UITraitCollection {
        UITraitCollection(
            style: style,
            displayScale: 3,
            displayGamut: .P3,
            layoutDirection: .leftToRight,
            contentSize: contentSize,
            userInterfaceIdiom: .phone,
            horizontalSizeClass: .compact,
            verticalSizeClass: .regular
        )
    }
}

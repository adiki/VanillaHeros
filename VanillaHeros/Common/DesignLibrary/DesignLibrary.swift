//
//  DesignLibrary.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 11/09/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

struct DesignLibrary {
    let colors: Colors
    let primaryButton: () -> UIButton
    let label: () -> UILabel
    let `switch`: () -> UISwitch
}

extension DesignLibrary {
    enum Metrics {
        enum Padding {
            static let standard = CGFloat(16)
        }
        enum PrimaryButton {
            static let cornerRadius = CGFloat(16)
            static let height = CGFloat(50)
        }
    }
    
    static let current = DesignLibrary.make(colors: .current)
    
    static func make(colors: Colors) -> DesignLibrary {
        DesignLibrary(
            colors: colors,
            primaryButton: {
                let primaryButton = UIButton()
                primaryButton.backgroundColor = colors.primary
                primaryButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).bold()
                primaryButton.layer.cornerRadius = Metrics.PrimaryButton.cornerRadius
                primaryButton.translatesAutoresizingMaskIntoConstraints = false
                primaryButton.heightAnchor.constraint(equalToConstant: Metrics.PrimaryButton.height).isActive = true
                return primaryButton
            },
            label: {
                let label = UILabel()
                label.textColor = colors.text
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            },
            switch: {
                let `switch` = UISwitch()
                `switch`.onTintColor = .red
                `switch`.translatesAutoresizingMaskIntoConstraints = false
                return `switch`
            }
        )
    }
}

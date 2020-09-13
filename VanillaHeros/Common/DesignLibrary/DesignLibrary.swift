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
    let imageView: () -> UIImageView
    let `switch`: () -> UISwitch
    let scrollView: () -> UIScrollView
    let stackView: () -> UIStackView
}

extension DesignLibrary {
    enum Metrics {
        enum Padding {
            static let standard = CGFloat(16)
        }
        enum PrimaryButton {
            static let cornerRadius = CGFloat(8)
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
            imageView: {
                let imageView = UIImageView()
                imageView.backgroundColor = .gray
                imageView.translatesAutoresizingMaskIntoConstraints = false
                return imageView
            },
            switch: {
                let `switch` = UISwitch()
                `switch`.onTintColor = .red
                `switch`.translatesAutoresizingMaskIntoConstraints = false
                return `switch`
            },
            scrollView: {
                let scrollView = UIScrollView()
                scrollView.alwaysBounceVertical = true
                scrollView.translatesAutoresizingMaskIntoConstraints = false
                return scrollView
            },
            stackView: {
                let stackView = UIStackView()
                stackView.axis = .vertical
                stackView.spacing = Metrics.Padding.standard
                stackView.alignment = .center
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.translatesAutoresizingMaskIntoConstraints = false
                return stackView
            }
        )
    }
}

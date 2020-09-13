//
//  DetailsView.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class DetailsView: View {
    var favouritesButtonTapped: (() -> Void)?
    let scrollView: UIScrollView
    let stackView: UIStackView
    let heroImageView: UIImageView
    let heroNameLabel: UILabel
    let favouritesButton: UIButton
    let descriptionLabel: UILabel
    
    required init(designLibrary: DesignLibrary) {
        scrollView = designLibrary.scrollView()
        stackView = designLibrary.stackView()
        heroImageView = designLibrary.imageView()
        heroNameLabel = designLibrary.label()
        favouritesButton = designLibrary.primaryButton()
        descriptionLabel = designLibrary.label()
        super.init(designLibrary: designLibrary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        backgroundColor = designLibrary.colors.background
        heroImageView.backgroundColor = designLibrary.colors.imageViewBackground
        heroNameLabel.font = .preferredFont(forTextStyle: .title2)
        favouritesButton.addTarget(
            self,
            action: #selector(favouritesButtonTouchUpInside),
            for: .touchUpInside
        )
        descriptionLabel.numberOfLines = 0
    }
    
    override func setupLayout() {
        add(
            subview: scrollView,
            constraints: [
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        scrollView.add(
            subview: stackView,
            constraints: [
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ]
        )
        stackView.addArrangedSubview(heroImageView)
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor).isActive = true
        stackView.addArrangedSubview(heroNameLabel)
        let doublePadding = 2 * DesignLibrary.Metrics.Padding.standard
        stackView.addArrangedSubview(favouritesButton)
        favouritesButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -doublePadding).isActive = true
        stackView.addArrangedSubview(descriptionLabel)
        descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -doublePadding).isActive = true
    }
    
    @objc private func favouritesButtonTouchUpInside() {
        favouritesButtonTapped?()
    }
}

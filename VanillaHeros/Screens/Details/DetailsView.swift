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
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let heroImageView = UIImageView()
    let heroNameLabel = UILabel()
    let favouritesButton = UIButton()
    let descriptionLabel = UILabel()
    
    override func setupView() {
        backgroundColor = Colors.backgroundColor
        
        scrollView.alwaysBounceVertical = true
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let spacing = CGFloat(16)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        heroImageView.backgroundColor = .gray
        stackView.addArrangedSubview(heroImageView)
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor).isActive = true
        
        heroNameLabel.textColor = Colors.textColor
        heroNameLabel.font = .preferredFont(forTextStyle: .title2)
        stackView.addArrangedSubview(heroNameLabel)
        
        favouritesButton.addTarget(
            self,
            action: #selector(favouritesButtonTouchUpInside),
            for: .touchUpInside
        )
        favouritesButton.backgroundColor = Colors.buttonColor
        favouritesButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).bold()
        favouritesButton.layer.cornerRadius = 8
        stackView.addArrangedSubview(favouritesButton)
        favouritesButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -spacing * 2).isActive = true
        favouritesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        descriptionLabel.textColor = Colors.textColor
        descriptionLabel.numberOfLines = 0
        stackView.addArrangedSubview(descriptionLabel)
        descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -spacing * 2).isActive = true
    }
    
    @objc private func favouritesButtonTouchUpInside() {
        favouritesButtonTapped?()
    }
}

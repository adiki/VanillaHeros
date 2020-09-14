//
//  RootView.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class RootView: View {
    let activityIndicatorView: UIActivityIndicatorView
    let loadedView: LoadedView
    let failedView: FailedView
    
    required init(designLibrary: DesignLibrary) {
        activityIndicatorView = designLibrary.activityIndicatorView()
        loadedView = LoadedView(designLibrary: designLibrary)
        failedView = FailedView(designLibrary: designLibrary)
        super.init(designLibrary: designLibrary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearViews() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        loadedView.isHidden = true
        loadedView.noFavouritesHerosLabel.isHidden = true
        failedView.isHidden = true
    }
    
    override func setupView() {
        backgroundColor = designLibrary.colors.background
    }
    
    override func setupLayout() {
        add(
            subview: activityIndicatorView,
            constraints: [
                activityIndicatorView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
                activityIndicatorView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
            ]
        )
        add(
            subview: loadedView,
            constraints: [
                loadedView.leadingAnchor.constraint(equalTo: leadingAnchor),
                loadedView.trailingAnchor.constraint(equalTo: trailingAnchor),
                loadedView.topAnchor.constraint(equalTo: topAnchor),
                loadedView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        add(
            subview: failedView,
            constraints: [
                failedView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                failedView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                failedView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
            ]
        )
    }
}

class LoadedView: View {
    let tableView: UITableView
    let noFavouritesHerosLabel: UILabel
    
    required init(designLibrary: DesignLibrary) {
        tableView = designLibrary.tableView()
        noFavouritesHerosLabel = designLibrary.label()
        super.init(designLibrary: designLibrary)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        tableView.backgroundColor = designLibrary.colors.background
        tableView.register(HeroCell.self)
        tableView.separatorStyle = .none
        noFavouritesHerosLabel.text = Strings.noFavouritesHeros
    }
    
    override func setupLayout() {
        add(
            subview: tableView,
            constraints: [
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.topAnchor.constraint(equalTo: topAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        add(
            subview: noFavouritesHerosLabel,
            constraints: [
                noFavouritesHerosLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
                noFavouritesHerosLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
            ]
        )
    }
}

class HeroCell: UITableViewCell {
    enum Metrics {
        static let heroImageViewSize = CGFloat(44)
        static let chevronWidth = CGFloat(13)
    }
    let designLibrary = DesignLibrary.current
    private(set) lazy var additionalBackgroundView = designLibrary.view()
    private(set) lazy var heroImageView = designLibrary.imageView()
    private(set) lazy var nameLabel = designLibrary.label()
    private(set) lazy var chevron = designLibrary.imageView()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupLayout()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heroImageView.image = nil
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            additionalBackgroundView.backgroundColor = designLibrary.colors.rowHighlighted
        } else {
            additionalBackgroundView.backgroundColor = designLibrary.colors.row
        }
    }
    
    private func setupView() {
        backgroundColor = designLibrary.colors.background
        additionalBackgroundView.backgroundColor = designLibrary.colors.row
        additionalBackgroundView.layer.cornerRadius = 8
        heroImageView.layer.cornerRadius = Metrics.heroImageViewSize / 2
        heroImageView.backgroundColor = designLibrary.colors.imageViewBackground
        heroImageView.clipsToBounds = true
        chevron.contentMode = .scaleAspectFit
        chevron.image = UIImage(named: Images.chevron)
    }
    
    private func setupLayout() {
        let padding = DesignLibrary.Metrics.Padding.standard
        additionalBackgroundView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        contentView.add(
            subview: additionalBackgroundView,
            constraints: [
                additionalBackgroundView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                additionalBackgroundView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                additionalBackgroundView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                additionalBackgroundView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
            ]
        )
        additionalBackgroundView.add(
            subview: heroImageView,
            constraints: [
                heroImageView.leadingAnchor.constraint(equalTo: additionalBackgroundView.layoutMarginsGuide.leadingAnchor),
                heroImageView.topAnchor.constraint(equalTo: additionalBackgroundView.layoutMarginsGuide.topAnchor),
                heroImageView.bottomAnchor.constraint(equalTo: additionalBackgroundView.layoutMarginsGuide.bottomAnchor),
                heroImageView.widthAnchor.constraint(equalToConstant: Metrics.heroImageViewSize),
                heroImageView.heightAnchor.constraint(equalToConstant: Metrics.heroImageViewSize)
            ]
        )
        additionalBackgroundView.add(
            subview: nameLabel,
            constraints: [
                nameLabel.leadingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: padding),
                nameLabel.topAnchor.constraint(equalTo: additionalBackgroundView.layoutMarginsGuide.topAnchor),
                nameLabel.bottomAnchor.constraint(equalTo: additionalBackgroundView.layoutMarginsGuide.bottomAnchor)
            ]
        )
        
        additionalBackgroundView.add(
            subview: chevron,
            constraints: [
                chevron.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: padding),
                chevron.trailingAnchor.constraint(equalTo: additionalBackgroundView.layoutMarginsGuide.trailingAnchor),
                chevron.topAnchor.constraint(equalTo: additionalBackgroundView.layoutMarginsGuide.topAnchor),
                chevron.bottomAnchor.constraint(equalTo: additionalBackgroundView.layoutMarginsGuide.bottomAnchor),
                chevron.widthAnchor.constraint(equalToConstant: Metrics.chevronWidth)
            ]
        )
    }
}

class FailedView: View {
    var retryTapped: (() -> Void)?
    let failedLabel: UILabel
    let retryButton: UIButton
    
    required init(designLibrary: DesignLibrary) {
        failedLabel = designLibrary.label()
        retryButton = designLibrary.primaryButton()
        super.init(designLibrary: designLibrary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        failedLabel.text = Strings.didFailToLoadHeros
        failedLabel.textAlignment = .center
        retryButton.addTarget(self, action: #selector(retryTouchUpInside), for: .touchUpInside)
        retryButton.setTitle(Strings.retry, for: .normal)
    }
    
    override func setupLayout() {
        add(
            subview: failedLabel,
            constraints: [
                failedLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                failedLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                failedLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
            ]
        )
        add(
            subview: retryButton,
            constraints: [
                retryButton.topAnchor.constraint(equalTo: failedLabel.bottomAnchor, constant: DesignLibrary.Metrics.Padding.standard),
                retryButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: DesignLibrary.Metrics.Padding.standard),
                retryButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                retryButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
            ]
        )
    }
    
    @objc private func retryTouchUpInside() {
        retryTapped?()
    }
}

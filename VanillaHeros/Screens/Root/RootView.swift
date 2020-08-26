//
//  RootView.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class RootView: UIView {
    let loadingView = UIActivityIndicatorView(style: .whiteLarge)
    let loadedView = LoadedView()
    let failedView = FailedView()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearViews() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
        loadedView.isHidden = true
        loadedView.noFavouritesHerosLabel.isHidden = true
        failedView.isHidden = true
    }
    
    private func setupView() {
        backgroundColor = Colors.backgroundColor
        
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
        
        addSubview(loadedView)
        loadedView.translatesAutoresizingMaskIntoConstraints = false
        loadedView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        loadedView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        loadedView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loadedView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        addSubview(failedView)
        failedView.translatesAutoresizingMaskIntoConstraints = false
        failedView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        failedView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        failedView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
    }
}

class LoadedView: UIView, UITableViewDataSource, UITableViewDelegate {
    var didSelectHero: ((Hero) -> Void)?
    var needsPictureForHero: ((Hero) -> Void)?
    var isFavouritesOnlyFilterOn = false
    var allHeros = [Hero]() {
        didSet {
            if isFavouritesOnlyFilterOn {
                herosToPresent = allHeros.filter {
                    favouriteHeroIds.contains($0.id)
                }
            } else {
                herosToPresent = allHeros
            }
        }
    }
    var herosToPresent = [Hero]() {
        didSet {
            if herosToPresent != oldValue {
                tableView.reloadData()
            }
        }
    }
    var herosToImageData = [Hero: Data]() {
        didSet {
            reloadImages()
        }
    }
    var favouriteHeroIds = Set<Int>() {
        didSet {
            if favouriteHeroIds != oldValue {
                reloadVisibleCells()
            }            
        }
    }
    let tableView = UITableView()
    let noFavouritesHerosLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        tableView.backgroundColor = Colors.backgroundColor
        
        tableView.register(HeroCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        noFavouritesHerosLabel.text = Strings.noFavouritesHeros
        noFavouritesHerosLabel.textColor = Colors.textColor
        addSubview(noFavouritesHerosLabel)
        noFavouritesHerosLabel.translatesAutoresizingMaskIntoConstraints = false
        noFavouritesHerosLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        noFavouritesHerosLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        herosToPresent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let heroCell = tableView.dequeueReusableCell(HeroCell.self)
        configure(heroCell: heroCell, indexPath: indexPath)
        return heroCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = herosToPresent[indexPath.row]
        didSelectHero?(hero)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func reloadImages() {
        tableView.reloadVisibleCells(
            predicate: { indexPath in
                let hero = herosToPresent[indexPath.row]
                return herosToImageData[hero] != nil
            },
            configure: configure(heroCell:indexPath:)
        )
    }
    
    private func reloadVisibleCells() {
        tableView.reloadVisibleCells(
            configure: configure(heroCell:indexPath:)
        )
    }
    
    private func configure(heroCell: HeroCell, indexPath: IndexPath) {
        let hero = herosToPresent[indexPath.row]
        if let heroImage = herosToImageData[hero].flatMap(UIImage.init(data:)) {
            heroCell.heroImageView.image = heroImage
        } else {
            needsPictureForHero?(hero)
        }
        if favouriteHeroIds.contains(hero.id) {
            heroCell.nameLabel.text = "\("⭐️") \(hero.name)"
        } else {
            heroCell.nameLabel.text = hero.name
        }
        
        heroCell.selectionStyle = .none
    }
}

class HeroCell: UITableViewCell {
    let backView = UIView()
    let heroImageView = UIImageView()
    let nameLabel = UILabel()
    let chevron = UIImageView()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heroImageView.image = nil
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            backView.backgroundColor = .darkGray
        } else {
            backView.backgroundColor = Colors.rowColor
        }
    }
    
    private func setupView() {
        backgroundColor = Colors.backgroundColor
        
        backView.backgroundColor = Colors.rowColor
        backView.layer.cornerRadius = 8
        let padding = CGFloat(16)
        backView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        contentView.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        backView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        backView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        let heroImageViewSize = CGFloat(44)
        heroImageView.backgroundColor = .gray
        heroImageView.layer.cornerRadius = heroImageViewSize / 2
        heroImageView.clipsToBounds = true
        backView.addSubview(heroImageView)
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.leadingAnchor.constraint(equalTo: backView.layoutMarginsGuide.leadingAnchor).isActive = true
        heroImageView.topAnchor.constraint(equalTo: backView.layoutMarginsGuide.topAnchor).isActive = true
        heroImageView.bottomAnchor.constraint(equalTo: backView.layoutMarginsGuide.bottomAnchor).isActive = true
        heroImageView.widthAnchor.constraint(equalToConstant: heroImageViewSize).isActive = true
        heroImageView.heightAnchor.constraint(equalToConstant: heroImageViewSize).isActive = true
        
        nameLabel.textColor = Colors.textColor
        backView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: padding).isActive = true
        nameLabel.topAnchor.constraint(equalTo: backView.layoutMarginsGuide.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: backView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        chevron.contentMode = .scaleAspectFit
        chevron.image = UIImage(named: Images.chevron)
        backView.addSubview(chevron)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: padding).isActive = true
        chevron.trailingAnchor.constraint(equalTo: backView.layoutMarginsGuide.trailingAnchor).isActive = true
        chevron.topAnchor.constraint(equalTo: backView.layoutMarginsGuide.topAnchor).isActive = true
        chevron.bottomAnchor.constraint(equalTo: backView.layoutMarginsGuide.bottomAnchor).isActive = true
        chevron.widthAnchor.constraint(equalToConstant: 13).isActive = true
    }
}

class FailedView: UIView {
    var retryTapped: (() -> Void)?
    let failedLabel = UILabel()
    let retryButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        failedLabel.text = Strings.didFailToLoadHeros
        failedLabel.textColor = Colors.textColor
        failedLabel.textAlignment = .center
        addSubview(failedLabel)
        failedLabel.translatesAutoresizingMaskIntoConstraints = false
        failedLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        failedLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        failedLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        retryButton.addTarget(self, action: #selector(retryTouchUpInside), for: .touchUpInside)
        retryButton.backgroundColor = Colors.buttonColor
        retryButton.layer.cornerRadius = 8
        retryButton.setTitle(Strings.retry, for: .normal)
        addSubview(retryButton)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.topAnchor.constraint(equalTo: failedLabel.bottomAnchor, constant: 16).isActive = true
        retryButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 16).isActive = true
        retryButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        retryButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        retryButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc private func retryTouchUpInside() {
        retryTapped?()
    }
}

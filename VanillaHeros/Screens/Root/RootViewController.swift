//
//  RootViewController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class RootViewController: ViewController<RootView> {
    private let viewModel: RootViewModel
    
    private var isFavouritesOnlyFilterOn = false
    private var allHeros = [Hero]() {
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
    private var herosToPresent = [Hero]() {
        didSet {
            if herosToPresent != oldValue {
                actualView.loadedView.tableView.reloadData()
            }
        }
    }
    private var herosToImageData = [Hero: Data]() {
        didSet {
            reloadImages()
        }
    }
    private var favouriteHeroIds = Set<Int>() {
        didSet {
            if favouriteHeroIds != oldValue {
                reloadVisibleCells()
            }
        }
    }
    
    init(
        viewModel: RootViewModel,
        designLibrary: DesignLibrary
    ) {
        self.viewModel = viewModel
        super.init(designLibrary: designLibrary)
        
        self.viewModel.store.didUpdateState = { [weak self] state in
            DispatchQueue.main.async {
                self?.actualView.clearViews()
                self?.render(state: state)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        actualView.loadedView.tableView.dataSource = self
        actualView.loadedView.tableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.send(action: .load)
    }
    
    func render(state: RootViewModel.State) {
        switch state.status {
        case .idle:
            break
        case .loading:
            actualView.activityIndicatorView.isHidden = false
            actualView.activityIndicatorView.startAnimating()
        case .loaded:
            isFavouritesOnlyFilterOn = state.isFavouritesOnlyFilterOn
            herosToImageData = state.herosToImageData
            favouriteHeroIds = state.favouriteHeroIds
            allHeros = state.heros
            actualView.loadedView.isHidden = false
            actualView.loadedView.noFavouritesHerosLabel.isHidden =
                state.isFavouritesOnlyFilterOn == false || state.favouriteHeroIds.isEmpty == false
        case .failed:
            actualView.failedView.isHidden = false
            actualView.failedView.retryTapped = { [weak self] in
                self?.viewModel.send(action: .retry)
            }
        }
    }
    
    private func setupViews() {
        navigationItem.titleView = UIImageView(image: UIImage(named: Images.marvelLogo))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Strings.filters,
            style: .plain,
            target: self,
            action: #selector(filtersItemTapped)
        )
    }
    
    @objc private func filtersItemTapped() {
        viewModel.send(action: .openFilters)
    }
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate {
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
        viewModel.send(action: .didSelect(hero: hero))
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func reloadImages() {
        actualView.loadedView.tableView.reloadVisibleCells(
            predicate: { indexPath in
                let hero = herosToPresent[indexPath.row]
                return herosToImageData[hero] != nil
            },
            configure: configure(heroCell:indexPath:)
        )
    }
    
    private func reloadVisibleCells() {
        actualView.loadedView.tableView.reloadVisibleCells(
            configure: configure(heroCell:indexPath:)
        )
    }
    
    private func configure(heroCell: HeroCell, indexPath: IndexPath) {
        let hero = herosToPresent[indexPath.row]
        if let heroImage = herosToImageData[hero].flatMap(UIImage.init(data:)) {
            heroCell.heroImageView.image = heroImage
        } else {
            viewModel.send(action: .needsPictureForHero(hero: hero))
        }
        if favouriteHeroIds.contains(hero.id) {
            heroCell.nameLabel.text = "\("⭐️") \(hero.name)"
        } else {
            heroCell.nameLabel.text = hero.name
        }
        
        heroCell.selectionStyle = .none
    }
}

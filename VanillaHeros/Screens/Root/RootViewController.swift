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
            actualView.loadedView.isHidden = false
            actualView.loadedView.isFavouritesOnlyFilterOn = state.isFavouritesOnlyFilterOn
            actualView.loadedView.herosToImageData = state.herosToImageData
            actualView.loadedView.favouriteHeroIds = state.favouriteHeroIds
            actualView.loadedView.allHeros = state.heros
            actualView.loadedView.didSelectHero = { [weak self] hero in
                self?.viewModel.send(action: .didSelect(hero: hero))
            }
            actualView.loadedView.needsPictureForHero = { [weak self] hero in
                self?.viewModel.send(action: .needsPictureForHero(hero: hero))
            }
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

//
//  RootViewController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    private let viewModel: RootViewModel
    
    var rootView: RootView {
        return view as! RootView
    }
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.store.didUpdateState = { [weak self] state in
            DispatchQueue.main.async {
                self?.rootView.clearViews()
                self?.render(state: state)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = RootView()
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
            rootView.loadingView.isHidden = false
            rootView.loadingView.startAnimating()
        case .loaded:
            rootView.loadedView.isHidden = false
            rootView.loadedView.isFavouritesOnlyFilterOn = state.isFavouritesOnlyFilterOn
            rootView.loadedView.herosToImageData = state.herosToImageData
            rootView.loadedView.favouriteHeroIds = state.favouriteHeroIds
            rootView.loadedView.allHeros = state.heros
            rootView.loadedView.didSelectHero = { [weak self] hero in
                self?.viewModel.send(action: .didSelect(hero: hero))
            }
            rootView.loadedView.needsPictureForHero = { [weak self] hero in
                self?.viewModel.send(action: .needsPictureForHero(hero: hero))
            }
            rootView.loadedView.noFavouritesHerosLabel.isHidden =
                state.isFavouritesOnlyFilterOn == false || state.favouriteHeroIds.count > 0
        case .failed:
            rootView.failedView.isHidden = false
            rootView.failedView.retryTapped = { [weak self] in
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

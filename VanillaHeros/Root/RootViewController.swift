//
//  RootViewController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    private let rootViewModel: RootViewModel
    
    var rootView: RootView {
        return view as! RootView
    }
    
    init(rootViewModel: RootViewModel) {
        self.rootViewModel = rootViewModel
        super.init(nibName: nil, bundle: nil)
        
        self.rootViewModel.store.didUpdateState = { [weak self] state in
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
        rootViewModel.send(action: .load)
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
            rootView.loadedView.heros = state.heros
            rootView.loadedView.herosToImageData = state.herosToImageData
            rootView.loadedView.favouriteHeroIds = state.favouriteHeroIds
            rootView.loadedView.didSelectHero = { [weak self] hero in
                self?.rootViewModel.send(action: .didSelect(hero: hero))
            }
            rootView.loadedView.needsPictureForHero = { [weak self] hero in
                self?.rootViewModel.send(action: .needsPictureForHero(hero: hero))
            }
        case .failed:
            rootView.failedView.isHidden = false
            rootView.failedView.retryTapped = { [weak self] in
                self?.rootViewModel.send(action: .retry)
            }
        }
    }
    
    private func setupViews() {
        navigationItem.titleView = UIImageView(image: UIImage(named: Images.marvelLogo))        
    }
}

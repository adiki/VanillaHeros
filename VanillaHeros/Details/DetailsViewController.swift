//
//  DetailsViewController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    private let detailsViewModel: DetailsViewModel
    
    var detailsView: DetailsView {
        return view as! DetailsView
    }
    
    init(detailsViewModel: DetailsViewModel) {
        self.detailsViewModel = detailsViewModel
        super.init(nibName: nil, bundle: nil)
        
        self.detailsViewModel.store.didUpdateState = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = DetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsViewModel.send(action: .initialize)
    }
    
    func render(state: DetailsViewModel.State) {
        detailsView.heroImageView.image = state.heroImageData.flatMap(UIImage.init(data:))
        detailsView.heroNameLabel.text = state.hero.name
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailsView.favouritesButton.setTitle(
            state.isHeroFavourite ? Strings.removeFromFavourites : Strings.addToFavourites,
            for: .normal
        )
        detailsView.favouritesButtonTapped = { [weak self] in
            self?.detailsViewModel.send(action: .favouritesButtonTapped)
        }
        if state.hero.description.isEmpty {
            detailsView.descriptionLabel.font = font.italic()
            detailsView.descriptionLabel.text = Strings.thisHeroDoesNotHaveADescription
        } else {
            detailsView.descriptionLabel.font = font
            detailsView.descriptionLabel.text = state.hero.description
        }
    }
}

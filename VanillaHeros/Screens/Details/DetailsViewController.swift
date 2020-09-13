//
//  DetailsViewController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class DetailsViewController: ViewController<DetailsView> {
    private let viewModel: DetailsViewModel

    init(
        viewModel: DetailsViewModel,
        designLibrary: DesignLibrary
    ) {
        self.viewModel = viewModel
        super.init(designLibrary: designLibrary)
        
        self.viewModel.store.didUpdateState = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.send(action: .initialize)
    }
    
    func render(state: DetailsViewModel.State) {
        actualView.heroImageView.image = state.heroImageData.flatMap(UIImage.init(data:))
        actualView.heroNameLabel.text = state.hero.name
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        actualView.favouritesButton.setTitle(
            state.isHeroFavourite ? Strings.removeFromFavourites : Strings.addToFavourites,
            for: .normal
        )
        actualView.favouritesButtonTapped = { [weak self] in
            self?.viewModel.send(action: .favouritesButtonTapped)
        }
        if state.hero.description.isEmpty {
            actualView.descriptionLabel.font = font.italic()
            actualView.descriptionLabel.text = Strings.thisHeroDoesNotHaveADescription
        } else {
            actualView.descriptionLabel.font = font
            actualView.descriptionLabel.text = state.hero.description
        }
    }
}

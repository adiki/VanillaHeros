//
//  FiltersViewController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class FiltersViewController: ViewController<FiltersView> {
    private let viewModel: FiltersViewModel
    
    init(
        viewModel: FiltersViewModel,
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
    
    func render(state: FiltersViewModel.State) {
        actualView.favouritesSwitchChangedValue = { [weak self] isOn in
            self?.viewModel.send(action: .favouritesOnlyFilterChanged(isOn: isOn))
        }
        actualView.favouritesSwitch.isOn = state.isFavouritesOnlyFilterOn
        actualView.doneButtonTapped = { [weak self] in
            self?.viewModel.send(action: .done)            
        }
    }
}

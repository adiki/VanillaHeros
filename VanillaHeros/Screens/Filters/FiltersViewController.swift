//
//  FiltersViewController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    private let viewModel: FiltersViewModel
    
    var filtersView: FiltersView {
        return view as! FiltersView
    }
    
    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.store.didUpdateState = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = FiltersView()
    }
    
    func render(state: FiltersViewModel.State) {
        filtersView.favouritesSwitchChangedValue = { [weak self] isOn in
            self?.viewModel.send(action: .favouritesOnlyFilterChanged(isOn: isOn))
        }
        filtersView.favouritesSwitch.isOn = state.isFavouritesOnlyFilterOn
        filtersView.doneButtonTapped = { [weak self] in
            self?.viewModel.send(action: .done)            
        }
    }
}

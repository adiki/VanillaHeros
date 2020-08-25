//
//  FiltersBuilder.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

enum FiltersBuilder {
    static func make(presentingViewController: UIViewController) -> UIViewController {
        let environment = FiltersViewModel.Environment(
            favourites: FavouritesManager.shared
        )
        let viewModel = FiltersViewModel(environment: environment)
        let viewController = FiltersViewController(viewModel: viewModel)
        let routesController = FiltersRouteController(
            presentingViewController: presentingViewController
        )
        viewModel.store.handleRoute = { route in
            routesController.handle(route: route)
        }
        return viewController
    }
}

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
        let viewModel = FiltersViewModel(
            environment: environment,
            scheduler: DispatchScheduler(dispatchQueue: .global())
        )
        let viewController = FiltersViewController(
            viewModel: viewModel,
            designLibrary: .current
        )
        let routesController = FiltersRouteController(
            presentingViewController: presentingViewController
        )
        viewModel.store.handleRoute = { route in
            DispatchQueue.main.async {
                routesController.handle(route: route)
            }
        }
        return viewController
    }
}

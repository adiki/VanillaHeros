//
//  RootBuilder.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

enum RootBuilder {
    static func make() -> UIViewController {
        let environment = RootViewModel.Environment(
            favourites: FavouritesManager.shared,
            herosProvider: HerosNetworkProvider(
                urlSession: URLSession.shared,
                jsonDecoder: JSONDecoder()
            )
        )
        let viewModel = RootViewModel(environment: environment)
        let rootViewController = RootViewController(viewModel: viewModel)
        let navigationController = UINavigationController(
            rootViewController: rootViewController
        )
        let routesController = RootRoutesController(
            navigationController: navigationController
        )
        viewModel.store.handleRoute = { route in
            routesController.handle(route: route)
        }
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
        return navigationController
    }
}

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
            ),
            synchronize: DispatchGroupSynchronize()
        )
        let viewModel = RootViewModel(
            environment: environment,
            scheduler: DispatchScheduler(dispatchQueue: .global())
        )
        let rootViewController = RootViewController(viewModel: viewModel)
        let navigationController = UINavigationController(
            rootViewController: rootViewController
        )
        let routesController = RootRoutesController(
            navigationController: navigationController
        )
        viewModel.store.handleRoute = { route in
            DispatchQueue.main.async {
                routesController.handle(route: route)
            }
        }
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
        return navigationController
    }
}

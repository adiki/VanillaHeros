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
        let rootEnvironment = RootViewModel.Environment(
            herosProvider: HerosNetworkProvider.shared
        )
        let rootViewModel = RootViewModel(environment: rootEnvironment)
        let rootViewController = RootViewController(rootViewModel: rootViewModel)
        let navigationController = UINavigationController(
            rootViewController: rootViewController
        )
        let rootRouteController = RootRouteController(navigationController: navigationController)
        rootViewModel.store.handleRoute = { route in
            rootRouteController.handle(route: route)
        }
        
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
        return navigationController
    }
}

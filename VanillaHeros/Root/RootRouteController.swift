//
//  RootRouteController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

struct RootRouteController {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func handle(route: RootViewModel.Route) {
        switch route {
        case let .heroSelected(hero, heroImageData):
            let detailsViewController = DetailsBuilder.make(hero: hero, heroImageData: heroImageData)
            navigationController.pushViewController(detailsViewController, animated: true)
        }
    }
}

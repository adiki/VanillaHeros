//
//  FiltersRouteController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

struct FiltersRouteController {
    private let presentingViewController: UIViewController
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func handle(route: FiltersViewModel.Route) {
        switch route {
        case .done:
            presentingViewController.dismiss(animated: true)
        }
    }
}

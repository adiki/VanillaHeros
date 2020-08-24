//
//  DetailsBuilder.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

enum DetailsBuilder {
    static func make(hero: Hero, heroImageData: Data?) -> UIViewController {
        let detailsEnvironment = DetailsViewModel.Environment(
            herosProvider: HerosNetworkProvider.shared
        )
        let detailsViewModel = DetailsViewModel(
            hero: hero,
            heroImageData: heroImageData,
            environment: detailsEnvironment
        )
        return DetailsViewController(detailsViewModel: detailsViewModel)
    }
}


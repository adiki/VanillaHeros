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
        let environment = DetailsViewModel.Environment(
            favourites: FavouritesManager.shared,
            herosProvider: HerosNetworkProvider(
                urlSession: URLSession.shared,
                jsonDecoder: JSONDecoder()
            )
        )
        let viewModel = DetailsViewModel(
            hero: hero,
            heroImageData: heroImageData,
            environment: environment,
            scheduler: DispatchScheduler(dispatchQueue: .global())
        )
        return DetailsViewController(
            viewModel: viewModel,
            designLibrary: .current
        )
    }
}


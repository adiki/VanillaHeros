//
//  DetailsViewModel.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct DetailsViewModel: ViewModel {
    var store: Store<State, Action, Environment, Route>
    
    init(
        hero: Hero,
        heroImageData: Data?,
        environment: Environment,
        scheduler: Scheduler
    ) {
        store = Store(
            initialState: State(
                hero: hero,
                heroImageData: heroImageData
            ),
            environment: environment,
            reduce: Self.reduce,
            scheduler: scheduler
        )
    }
    
    func send(action: Action) {
        store.send(action: action)
    }
    
    static func reduce(state: inout State, action: Action, environment: Environment) -> Outcome<Action, Route> {
        switch action {
        case .initialize:
            let hero = state.hero
            state.isHeroFavourite = environment.favourites.isHeroFavourite(hero: hero)
            if state.heroImageData == nil {
                return .effect(Effect<Action> { completion in
                    environment.herosProvider.imageData(forHero: hero) { result in
                        switch result {
                        case .success(let data):
                            completion(.didFetchImageData(data: data))
                        case .failure:
                            completion(.didFailToFetchHeroImageData)
                        }
                    }
                })
            } else {
                return .none
            }
        case let .didFetchImageData(data):
            state.heroImageData = data
            return .none
        case .didFailToFetchHeroImageData:
            return .none
        case .favouritesButtonTapped:
            let hero = state.hero
            if environment.favourites.isHeroFavourite(hero: hero) {
                environment.favourites.removeHeroFromFavourites(hero: hero)
            } else {
                environment.favourites.addHeroToFavourites(hero: hero)
            }
            state.isHeroFavourite = environment.favourites.isHeroFavourite(hero: hero)
            return .effect(Effect<Action> { completion in
                environment.favourites.saveFavourites { result in
                    switch result {
                    case let .failure(error):
                        completion(.didFailToSaveFavourites(error: error))
                    }
                }
            })
        case .didFailToSaveFavourites:
            return .none
        }
    }
 
    struct State {
        let hero: Hero
        var heroImageData: Data?
        var isHeroFavourite: Bool = false
    }
    
    enum Action {
        case initialize
        case didFetchImageData(data: Data)
        case didFailToFetchHeroImageData
        case favouritesButtonTapped
        case didFailToSaveFavourites(error: Error)
    }
    
    struct Environment {
        let favourites: Favourites
        let herosProvider: HerosProvider
    }
    
    enum Route {
    }
}

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
        environment: Environment
    ) {
        store = Store(
            initialState: State(
                hero: hero,
                heroImageData: heroImageData
            ),
            environment: environment,
            reduce: Self.reduce
        )
    }
    
    func send(action: Action) {
        store.send(action: action)
    }
    
    static func reduce(state: inout State, action: Action, environment: Environment) -> Outcome<Action, Route> {
        switch action {
        case .initialize:
            let hero = state.hero
            state.isHeroFavourite = environment.herosProvider.isHeroFavourite(hero: hero)
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
            if environment.herosProvider.isHeroFavourite(hero: hero) {
                environment.herosProvider.removeHeroFromFavourites(hero: hero)
            } else {
                environment.herosProvider.addHeroToFavourites(hero: hero)
            }
            state.isHeroFavourite = environment.herosProvider.isHeroFavourite(hero: hero)
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
    }
    
    struct Environment {
        let herosProvider: HerosProvider
    }
    
    enum Route {
    }
}

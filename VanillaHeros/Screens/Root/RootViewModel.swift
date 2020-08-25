//
//  File.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct RootViewModel: ViewModel {
    var store: Store<State, Action, Environment, Route>
    
    init(environment: Environment) {
        store = Store(
            initialState: State(
                isFavouritesOnlyFilterOn: environment.favourites.isFavouritesOnlyFilterOn
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
        case .load, .retry:
            state.status = .loading
            var effects = [
                Effect<Action> { completion in
                    synchronize(
                        environment.herosProvider.fetchHeros,
                        environment.favourites.loadFavourites
                    ) { result in
                        switch result {
                        case .success(let (heros, favourites)):
                            completion(.didLoad(heros: heros, favourites: favourites))
                        case .failure:
                            completion(.didFailToLoadHeros)
                        }
                    }
                }
            ]
            if state.favouritesDisposable == nil {
                effects.append(Effect<Action> { completion in
                    let disposable = environment.favourites.observeFavourites { favourites, isFavouritesOnlyFilterOn in
                        completion(.didUpdate(favourites: favourites, isFavouritesOnlyFilterOn: isFavouritesOnlyFilterOn))
                    }
                    completion(.didSubscribeToFavourites(disposable: disposable))
                })
            }
            return .effect(Effects.merge(effects: effects))
        case let .didLoad(heros: heros, favourites: favourites):
            state.status = .loaded
            state.heros = heros
            state.favouriteHeroIds = favourites
            return .none
        case .didFailToLoadHeros:
            state.status = .failed
            return .none
        case let .didFetchImageData(data, hero):
            state.herosToImageData[hero] = data
            return .none
        case .didFailToFetchHeroImageData:
            return .none
        case let .didSubscribeToFavourites(disposable):
            state.favouritesDisposable = disposable
            return .none
        case let .didSelect(hero):
            return .route(.heroSelected(
                hero: hero,
                heroImageData: state.herosToImageData[hero]
            ))
        case let .needsPictureForHero(hero):
            return .effect(Effect<Action> { completion in
                environment.herosProvider.imageData(forHero: hero) { result in
                    switch result {
                    case .success(let data):
                        completion(.didFetchImageData(data: data, hero: hero))
                    case .failure:
                        completion(.didFailToFetchHeroImageData)
                    }
                }
            })
        case let .didUpdate(favourites, isFavouritesOnlyFilterOn):
            state.favouriteHeroIds = favourites
            state.isFavouritesOnlyFilterOn = isFavouritesOnlyFilterOn
            return .none
        case .openFilters:
            return .route(.openFilters)
        }
    }
 
    struct State {
        var status = Status.idle
        var heros = [Hero]()
        var herosToImageData = [Hero: Data]()
        var favouriteHeroIds = Set<Int>()
        var isFavouritesOnlyFilterOn: Bool
        fileprivate var favouritesDisposable: Disposable?
    }
    
    enum Status {
        case idle
        case loading
        case loaded
        case failed
    }
    
    enum Action {
        case load
        case didLoad(heros: [Hero], favourites: Set<Int>)
        case didFailToLoadHeros
        case retry
        case didFetchImageData(data: Data, hero: Hero)
        case didFailToFetchHeroImageData
        case didSubscribeToFavourites(disposable: Disposable)
        case didSelect(hero: Hero)
        case needsPictureForHero(hero: Hero)
        case didUpdate(favourites: Set<Int>, isFavouritesOnlyFilterOn: Bool)
        case openFilters
    }
    
    struct Environment {
        let favourites: Favourites
        let herosProvider: HerosProvider
    }
    
    enum Route {
        case heroSelected(hero: Hero, heroImageData: Data?)
        case openFilters
    }
}

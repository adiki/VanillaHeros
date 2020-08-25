//
//  FiltersViewModel.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct FiltersViewModel: ViewModel {
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
        case let .favouritesOnlyFilterChanged(isOn):
            environment.favourites.isFavouritesOnlyFilterOn.toggle()
            state.isFavouritesOnlyFilterOn = environment.favourites.isFavouritesOnlyFilterOn
            return .none
        case .done:
            return .route(.done)
        }
    }
 
    struct State {
        var isFavouritesOnlyFilterOn = false
    }
    
    enum Action {
        case favouritesOnlyFilterChanged(isOn: Bool)
        case done
    }
    
    struct Environment {
        let favourites: Favourites
    }
    
    enum Route {
        case done
    }
}

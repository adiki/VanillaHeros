//
//  Store.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

class Store<State, Action, Environment, Route> {
    var didUpdateState: ((State) -> Void)? {
        didSet {
            didUpdateState?(state)
        }
    }
    var handleRoute: ((Route) -> Void)?
    private(set) var state: State
    private let environment: Environment
    private let reduce: (inout State, Action, Environment) -> Outcome<Action, Route>
    private let scheduler: Scheduler
    private let serialQueue = DispatchQueue(label: "Store serial queue")
    
    init(
        initialState: State,
        environment: Environment,
        reduce: @escaping (inout State, Action, Environment) -> Outcome<Action, Route>,
        scheduler: Scheduler
    ) {
        self.state = initialState
        self.environment = environment
        self.reduce = reduce
        self.scheduler = scheduler
    }
    
    func send(action: Action) {
        serialQueue.sync {
            let result = reduce(&state, action, environment)
            didUpdateState?(state)
            
            switch result {
            case .none:
                break
            case .effect(let effect):
                scheduler.async { [weak self] in
                    effect.run { action in
                        self?.send(action: action)
                    }
                }
            case .route(let route):
                handleRoute?(route)
            }
        }
    }
}

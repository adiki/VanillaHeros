//
//  ViewModel.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

protocol ViewModel {
    associatedtype State
    associatedtype Action
    associatedtype Environment
    associatedtype Route
    
    var store: Store<State, Action, Environment, Route> { get }
    
    mutating func send(action: Action)
    static func reduce(state: inout State, action: Action, environment: Environment) -> Outcome<Action, Route>
}

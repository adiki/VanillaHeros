//
//  Result.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

enum Outcome<Action, Route> {
    case none
    case effect(Effect<Action>)
    case route(Route)
}

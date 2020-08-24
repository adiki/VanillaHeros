//
//  Effect.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct Effect<Action> {
    let run: (@escaping (Action) -> Void) -> Void
}

enum Effects {
    static func merge<Action>(effects: [Effect<Action>]) -> Effect<Action> {
        Effect<Action> { completion in
            for effect in effects {
                effect.run(completion)
            }
        }
    }
}

//
//  Atomic.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

final class Atomic<A> {
    private let queue = DispatchQueue(label: "Atomic queue", attributes: .concurrent)
    private var _value: A

    init(_ value: A) {
        self._value = value
    }

    var value: A {
        get { return queue.sync { self._value } }
    }

    func mutate(_ transform: (inout A) -> ()) {
        queue.sync(flags: .barrier) { transform(&self._value) }
    }
}

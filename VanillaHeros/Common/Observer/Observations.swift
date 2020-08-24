//
//  Observations.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

class Observations<Subject> {
    class Reference {
    }
    
    private var observations = Atomic<[ObjectIdentifier: (Subject) -> Void]>([:])

    func add(callback: @escaping (Subject) -> Void) -> Disposable {
        let identifier = ObjectIdentifier(Reference())
        observations.mutate {
            $0[identifier] = callback
        }
        return Disposable { [weak self] in
            self?.removeCallback(identifier: identifier)
        }
    }

    func didUpdate(subject: Subject) {
        for callback in observations.value.values {
            callback(subject)
        }
    }
    
    private func removeCallback(identifier: ObjectIdentifier) {
        observations.mutate {
            $0[identifier] = nil
        }
    }
}

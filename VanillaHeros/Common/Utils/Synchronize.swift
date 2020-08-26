//
//  Concurrency.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

protocol Synchronize {
    func sync<A, B>(
        _ f: (@escaping (Result<A, Error>) -> Void) -> Void,
        _ g: (@escaping (Result<B, Error>) -> Void) -> Void,
        completion: @escaping (Result<(A, B), Error>) -> Void
    )
}

struct CombinedErrors: Error {
    let errors: [Error]
}

struct DispatchGroupSynchronize: Synchronize {
    func sync<A, B>(
        _ f: (@escaping (Result<A, Error>) -> Void) -> Void,
        _ g: (@escaping (Result<B, Error>) -> Void) -> Void,
        completion: @escaping (Result<(A, B), Error>) -> Void
    ) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        var resultA: Result<A, Error>!
        var resultB: Result<B, Error>!
        f { result in
            resultA = result
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        g { result in
            resultB = result
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .global()) {
            if case let .success(a) = resultA, case let .success(b) = resultB {
                completion(.success((a, b)))
            } else {
                completion(.failure(CombinedErrors(errors:
                    [resultA.error, resultB.error].compactMap { $0 }
                )))
            }
        }
    }
}

//
//  TestSynchronize.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 26/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

@testable import VanillaHeros

struct TestSynchronize: Synchronize {
    func sync<A, B>(
        _ f: (@escaping (Result<A, Error>) -> Void) -> Void,
        _ g: (@escaping (Result<B, Error>) -> Void) -> Void,
        completion: @escaping (Result<(A, B), Error>) -> Void
    ) {
        var resultA: Result<A, Error>!
        var resultB: Result<B, Error>!
        f { result in
            resultA = result
        }
        g { result in
            resultB = result
        }
        if case let .success(a) = resultA, case let .success(b) = resultB {
            completion(.success((a, b)))
        } else {
            completion(.failure(CombinedErrors(errors:
                [resultA.error, resultB.error].compactMap { $0 }
            )))
        }
    }
}

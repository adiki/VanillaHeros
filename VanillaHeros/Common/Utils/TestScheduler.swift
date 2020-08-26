//
//  TestScheduler.swift
//  VanillaHerosTests
//
//  Created by Adrian Śliwa on 26/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

@testable import VanillaHeros

class TestScheduler: Scheduler {
    var works = [() -> Void]()
    
    func advance() {
        for work in works {
            work()
        }
        works = []
    }
    
    func async(work: @escaping () -> Void) {
        works.append(work)
    }
}

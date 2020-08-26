//
//  Scheduler.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 26/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

protocol Scheduler {
    func async(work: @escaping () -> Void)
}

class DispatchScheduler: Scheduler {
    private let dispatchQueue: DispatchQueue
    
    init(dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
    }
    
    func async(work: @escaping () -> Void) {
        dispatchQueue.async(execute: work)
    }
}

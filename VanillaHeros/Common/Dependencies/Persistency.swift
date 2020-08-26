//
//  Persistency.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

protocol Persistency {
    func load(forName name: String, completion: (Result<Data, Error>) -> Void)
    func save(data: Data, forName name: String, completion: (Result<Never, Error>) -> Void)
}

struct FilePersistency: Persistency {
    func load(forName name: String, completion: (Result<Data, Error>) -> Void) {
        let fileURL = self.fileURL(forName: name)
        do {
            let data = try Data(contentsOf: fileURL)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(data: Data, forName name: String, completion: (Result<Never, Error>) -> Void) {
        do {
            let fileURL = self.fileURL(forName: name)
            try data.write(to: fileURL)
        } catch {
            completion(.failure(error))
        }
    }
    
    private func fileURL(forName name: String) -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentsPath)
        return documentsUrl.appendingPathComponent(name)
    }
}

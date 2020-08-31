//
//  Favourites.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

protocol Favourites: class {
    var isFavouritesOnlyFilterOn: Bool { get set }
    func isHeroFavourite(hero: Hero) -> Bool
    func addHeroToFavourites(hero: Hero) -> Void
    func removeHeroFromFavourites(hero: Hero) -> Void
    func observeFavourites(callback: @escaping (Set<Int>, Bool) -> Void) -> Disposable
    func saveFavourites(completion: (Result<Never, Error>) -> Void)
    func loadFavourites(completion: (Result<Set<Int>, Error>) -> Void)
}

class FavouritesManager: Favourites {
    static let shared = FavouritesManager(
        persistency: FilePersistency(),
        jsonEncoder: JSONEncoder(),
        jsonDecoder: JSONDecoder()
    )
    let observations = Observations<(Set<Int>, Bool)>()
    var isFavouritesOnlyFilterOn = false {
        didSet {
            observations.didUpdate(subject: (favouriteHeroIds, isFavouritesOnlyFilterOn))
        }
    }
    private var favouriteHeroIds = Set<Int>()
    private let persistency: Persistency
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    init(persistency: Persistency, jsonEncoder: JSONEncoder, jsonDecoder: JSONDecoder) {
        self.persistency = persistency
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
    
    func isHeroFavourite(hero: Hero) -> Bool {
        favouriteHeroIds.contains(hero.id)
    }
    
    func addHeroToFavourites(hero: Hero) {
        favouriteHeroIds.insert(hero.id)
        observations.didUpdate(subject: (favouriteHeroIds, isFavouritesOnlyFilterOn))
    }
    
    func removeHeroFromFavourites(hero: Hero) {
        favouriteHeroIds.remove(hero.id)
        observations.didUpdate(subject: (favouriteHeroIds, isFavouritesOnlyFilterOn))
    }
    
    func observeFavourites(callback: @escaping (Set<Int>, Bool) -> Void) -> Disposable {
        observations.add(callback: callback)
    }
    
    func saveFavourites(completion: (Result<Never, Error>) -> Void) {
        do {
            let data = try jsonEncoder.encode(favouriteHeroIds)
            persistency.save(
                data: data,
                forName: Strings.favouritesFilename,
                completion: completion
            )
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadFavourites(completion: (Result<Set<Int>, Error>) -> Void) {
        persistency.load(forName: Strings.favouritesFilename) { [weak self] result in
            switch result {
            case let .success(data):
                do {
                    let favouriteHeroIds = try jsonDecoder.decode(Set<Int>.self, from: data)
                    self?.favouriteHeroIds = favouriteHeroIds
                    completion(.success(favouriteHeroIds))
                } catch {
                    completion(.failure(error))
                }
            case .failure:
                completion(.success([]))
            }
        }
    }
}

//
//  HerosProvider.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

protocol HerosProvider {
    func fetchHeros(completion: @escaping (Result<[Hero], Error>) -> Void)
    func imageData(forHero hero: Hero, completion: @escaping (Result<Data, Error>) -> Void)
    func isHeroFavourite(hero: Hero) -> Bool
    func addHeroToFavourites(hero: Hero) -> Void
    func removeHeroFromFavourites(hero: Hero) -> Void
    func observeFavourites(callback: @escaping ([Int]) -> Void) -> Disposable
}

enum ImageSize: String {
    case square = "standard_xlarge"
    case portrait = "portrait_fantastic"
}

enum ProviderError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case serverError
}

class HerosNetworkProvider: HerosProvider {
    static let shared = HerosNetworkProvider(
        urlSession: URLSession.shared,
        jsonDecoder: JSONDecoder()
    )
    let observations = Observations<[Int]>()
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    private var favouriteHeroIds = [Int]()
    
    init(
         urlSession: URLSession,
         jsonDecoder: JSONDecoder
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchHeros(completion: @escaping (Result<[Hero], Error>) -> Void) {
        guard let authenticatedURL = authenticatedURL(
            forPath: "https://gateway.marvel.com/v1/public/characters",
            additionalQueryItems: [URLQueryItem(name: "limit", value: "100")]
        ) else {
            return completion(.failure(ProviderError.invalidURL))
        }
        
        urlSession.dataTask(with: authenticatedURL) { [jsonDecoder] data, response, error in
            if let error = error {
                completion(.failure(ProviderError.networkError(error)))
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard (200...299).contains(statusCode) else {
                completion(.failure(ProviderError.serverError))
                return
            }
            if let data = data,
                    let response = try? jsonDecoder.decode(HeroResponse.self, from: data) {
                completion(.success(response.data.results))
            } else {
                completion(.failure(ProviderError.invalidResponse))
            }
        }
        .resume()
    }
    
    func imageData(forHero hero: Hero, completion: @escaping (Result<Data, Error>) -> Void) {
        imageData(
            forPath: hero.thumbnail.path,
            extension: hero.thumbnail.extension,
            imageSize: .square,
            completion: completion
        )
    }
    
    func isHeroFavourite(hero: Hero) -> Bool {
        favouriteHeroIds.contains(hero.id)
    }
    
    func addHeroToFavourites(hero: Hero) {
        favouriteHeroIds.append(hero.id)
        observations.didUpdate(subject: favouriteHeroIds)
    }
    
    func removeHeroFromFavourites(hero: Hero) {
        favouriteHeroIds.removeAll(where: { $0 == hero.id })
        observations.didUpdate(subject: favouriteHeroIds)
    }
    
    func observeFavourites(callback: @escaping ([Int]) -> Void) -> Disposable {
        observations.add(callback: callback)
    }
    
    private func imageData(
        forPath path: String,
        extension: String,
        imageSize: ImageSize,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let urlString = "\(path)/\(imageSize.rawValue).\(`extension`)"
            .replacingOccurrences(of: "http:", with: "https:")
        guard let url = URL(string: urlString) else {
            return completion(.failure(ProviderError.invalidURL))
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(ProviderError.networkError(error)))
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard (200...299).contains(statusCode) else {
                completion(.failure(ProviderError.serverError))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(ProviderError.invalidResponse))
            }
        }
        .resume()
    }
    
    private func authenticatedURL(forPath path: String, additionalQueryItems: [URLQueryItem] = []) -> URL? {
        let ts = Date().timeIntervalSince1970.description
        let privateKey = "3c8e16e3cece0b64b074150b8e36f4314b889762"
        let publicKey = "4e945060d999458c342c2cbedbef082c"
        var urlComponents = URLComponents(string: path)!
        urlComponents.scheme = "https"
        urlComponents.queryItems = [
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "hash", value: MD5(string: ts + privateKey + publicKey))
        ] + additionalQueryItems
        return urlComponents.url
    }
}

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
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
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
        
        urlSession.dataTask(with: authenticatedURL) { [weak self, jsonDecoder] data, response, error in
            self?.handleResponse(
                data: data,
                response: response,
                error: error,
                convert: { data in
                    let response = try jsonDecoder.decode(HeroResponse.self, from: data)
                    return response.data.results
                },
                completion: completion
            )
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
        
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            self?.handleResponse(
                data: data,
                response: response,
                error: error,
                convert: { $0 },
                completion: completion
            )
        }
        .resume()
    }

    private func handleResponse<T>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        convert: (Data) throws -> T,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let error = error {
            return completion(.failure(ProviderError.networkError(error)))
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
            (200...299).contains(statusCode) else {
            return completion(.failure(ProviderError.serverError))
        }
        if let data = data {
            do {
                let converted = try convert(data)
                completion(.success(converted))
            } catch {
                completion(.failure(ProviderError.invalidResponse))
            }
        } else {
            completion(.failure(ProviderError.invalidResponse))
        }
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

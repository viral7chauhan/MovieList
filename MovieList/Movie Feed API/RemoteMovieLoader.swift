//
//  RemoteMovieLoader.swift
//  MovieList
//
//  Created by Viral on 01/12/22.
//

import Foundation

public final class RemoteMovieLoader {
    private let client: HTTPClient
    private let url: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = Swift.Result<[MovieFeed], Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(_ completion: @escaping (RemoteMovieLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteMovieMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

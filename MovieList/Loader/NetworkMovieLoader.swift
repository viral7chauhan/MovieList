//
//  NetworkMovieLoader.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

public class NetworkMovieLoader: MovieLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = MovieLoader.Result

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(_ completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
                case let .success((data, response)):
                    completion(MovieFeedItemMapper.map(data, from: response))
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
}

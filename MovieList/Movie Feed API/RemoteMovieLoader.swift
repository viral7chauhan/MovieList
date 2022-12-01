//
//  RemoteMovieLoader.swift
//  MovieList
//
//  Created by Viral on 01/12/22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

public final class RemoteMovieLoader {
    private let client: HTTPClient
    private let url: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(_ completion: @escaping (Error) -> Void) {
        client.get(from: url) { error, response in
            if let response {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
        }
    }
}

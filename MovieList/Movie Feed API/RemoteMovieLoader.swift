//
//  RemoteMovieLoader.swift
//  MovieList
//
//  Created by Viral on 01/12/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}

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
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                completion(RemoteMovieLoader.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

   private static func map(data: Data, response: HTTPURLResponse) -> RemoteMovieLoader.Result {
//       guard Self.isOK(response) else {
           return .failure(.invalidData)
//       }
//       return
   }

    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode == 200
    }
}

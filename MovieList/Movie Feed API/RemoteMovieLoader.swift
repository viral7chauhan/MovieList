//
//  RemoteMovieLoader.swift
//  MovieList
//
//  Created by Viral on 01/12/22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteMovieLoader {
    private let client: HTTPClient
    private let url: URL

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load() {
        client.get(from: url)
    }
}

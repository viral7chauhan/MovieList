//
//  RemoteMovieLoader.swift
//  MovieListTests
//
//  Created by Viral on 01/12/22.
//

import XCTest

class RemoteMovieLoader {
    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load() {
        client.get(from: URL(string: "a-hrl.com")!)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteMovieLoaderTests: XCTestCase {
    func test_init_doesNotRequestData() {
        let client = HTTPClientSpy()
        _ = RemoteMovieLoader(client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_init_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(client: client)

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
}

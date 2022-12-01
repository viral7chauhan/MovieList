//
//  RemoteMovieLoader.swift
//  MovieListTests
//
//  Created by Viral on 01/12/22.
//

import XCTest

class RemoteMovieLoader {
    let client: HTTPClient
    let url: URL

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url)
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
        let url = URL(string: "http://another-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteMovieLoader(url: url, client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_init_requestDataFromURL() {
        let url = URL(string: "http://another-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client)

        sut.load()

        XCTAssertEqual(client.requestedURL, url)
    }
}

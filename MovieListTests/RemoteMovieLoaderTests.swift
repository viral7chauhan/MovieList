//
//  RemoteMovieLoader.swift
//  MovieListTests
//
//  Created by Viral on 01/12/22.
//

import XCTest
import MovieList

final class RemoteMovieLoaderTests: XCTestCase {
    func test_init_doesNotRequestData() {
        let (_ , client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() {
        let givenURL = URL(string: "https://another-url.com")!
        let (sut, client) = makeSUT(url: givenURL)

        sut.load()

        XCTAssertEqual(client.requestedURL, givenURL)
    }


    // MARK: - Helper
    private func makeSUT(url: URL = URL(string: "http://another-url.com")!)
    -> (sut: RemoteMovieLoader, client: HTTPClientSpy)
     {
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?

        func get(from url: URL) {
            requestedURL = url
        }
    }
}

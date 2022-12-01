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

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let givenURL = URL(string: "https://another-url.com")!
        let (sut, client) = makeSUT(url: givenURL)

        sut.load()

        XCTAssertEqual(client.requestedURLs, [givenURL])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let givenURL = URL(string: "https://another-url.com")!
        let (sut, client) = makeSUT(url: givenURL)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [givenURL, givenURL])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        var capturedErrors = [RemoteMovieLoader.Error]()
        sut.load { capturedErrors.append($0) }

        let clientError = NSError(domain: "test", code: 0)
        client.completion(with: clientError)

        XCTAssertEqual(capturedErrors, [.connectivity])
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
        private var messages = [(url: URL,
                                completion: (Error) -> Void)]()

        var requestedURLs: [URL] {
            messages.map(\.url)
        }

        func get(from url: URL, completion: @escaping (Error) -> Void) {
            messages.append((url, completion))
        }

        func completion(with error: Error, at index: Int = 0) {
            messages[index].completion(error)
        }
    }
}

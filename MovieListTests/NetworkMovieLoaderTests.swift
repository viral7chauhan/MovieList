//
//  NetworkMovieLoaderTests.swift
//  MovieListTests
//
//  Created by Viral on 07/12/22.
//

import XCTest
import MovieList


class HTTPClientSpy {
    var requestedURLs = [URL]()

    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, _ completion: @escaping (Result) -> Void) {
        requestedURLs.append(url)
    }
}

class NetworkMoveiLoader {
    let url: URL
    let client: HTTPClientSpy

    init(url: URL, client: HTTPClientSpy) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url) { _ in }
    }
}

final class NetworkMovieLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-another-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url])
    }

    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
                         file: StaticString = #filePath, line: UInt = #line)
    -> (sut: NetworkMoveiLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = NetworkMoveiLoader(url: url, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }


}

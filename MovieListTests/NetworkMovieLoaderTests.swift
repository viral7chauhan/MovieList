//
//  NetworkMovieLoaderTests.swift
//  MovieListTests
//
//  Created by Viral on 07/12/22.
//

import XCTest
import MovieList

final class NetworkMovieLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-another-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let givenURL = URL(string: "https://another-url.com")!
        let (sut, client) = makeSUT(url: givenURL)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [givenURL, givenURL])
    }

    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatus: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversSuccessWithNoItemOn200ResponseWithEmptyJsonList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            let json = makeItemsJSON([])
            client.complete(withStatus: 200, data: json)
        }
    }

    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
                         file: StaticString = #filePath, line: UInt = #line)
    -> (sut: NetworkMovieLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = NetworkMovieLoader(url: url, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }

    private func failure(_ error: NetworkMovieLoader.Error) -> NetworkMovieLoader.Result {
        return .failure(error)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json: [String: Any] = [
            "page": 1,
            "results": items
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func expect(_ sut: NetworkMovieLoader,
                        toCompleteWith expectedResult: NetworkMovieLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #filePath, line: UInt = #line) {

        let exp = expectation(description: "Wait for completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

                case let (.failure(receivedError as NetworkMovieLoader.Error),
                          .failure(expectedError as NetworkMovieLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)

                default:
                    XCTFail("Expected \(expectedResult) and received \(receivedResult) not matched", file: file, line: line)
            }
            exp.fulfill()

        }
        action()
        wait(for: [exp], timeout: 3.0)
    }

    private class HTTPClientSpy: HTTPClient {

        private var message = [(url: URL, completion: (HTTPClient.Result) -> Void)]()

        var requestedURLs: [URL] {
            message.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            message.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            message[index].completion(.failure(error))
        }

        func complete(withStatus code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!

            message[index].completion(.success((data, response)))
        }
    }

}

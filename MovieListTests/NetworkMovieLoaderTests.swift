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
        sut.load(url: url) { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let givenURL = URL(string: "https://another-url.com")!
        let (sut, client) = makeSUT(url: givenURL)

        sut.load(url: givenURL) { _ in }
        sut.load(url: givenURL) { _ in }

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

    func test_load_deliversSuccessWithItemsOn200ResponseWithJsonList() {
        let now = Date().stripTime()
        let (sut, client) = makeSUT()

        let item1 = MovieFeed(id: 2, title: "a movie", originalTitle: "The Movie", thumbnailImage: "xyz", bannerImage: "xyz", overview: "good", popularity: 25.6, releaseDate: now, voteCount: 5, isFavorite: false)


        let item2 = MovieFeed(id: 3, title: "another movie", originalTitle: "The Another Movie", thumbnailImage: "xyz", bannerImage: "xyz", overview: "good", popularity: 25.6, releaseDate: now, voteCount: 5, isFavorite: false)

        let items = [item1, item2]

        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatus: 200, data: json)
        }
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: NetworkMovieLoader? = NetworkMovieLoader(client: client)

        var capturedResults = [NetworkMovieLoader.Result]()
        sut?.load(url: url) { capturedResults.append($0) }

        sut = nil
        client.complete(withStatus: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
                         file: StaticString = #filePath, line: UInt = #line)
    -> (sut: NetworkMovieLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = NetworkMovieLoader(client: client)
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
        let url = URL(string: "https://any-url.com")!
        sut.load(url: url) { receivedResult in
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
}

private extension MovieFeed {
    static var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    var json: [String: Any] {
        return [
            "id": id,
            "original_title": originalTitle,
            "overview": overview ?? "",
            "release_date": MovieFeed.formatter.string(from: releaseDate),
            "title": title,
            "vote_count": voteCount,
            "popularity": popularity,
            "backdrop_path": thumbnailImage ?? "",
            "poster_path": bannerImage ?? "",
        ]
    }
}

private extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}

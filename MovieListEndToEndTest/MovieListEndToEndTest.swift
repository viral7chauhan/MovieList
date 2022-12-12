//
//  MovieListEndToEndTest.swift
//  MovieListEndToEndTest
//
//  Created by Viral on 12/12/22.
//

import XCTest
import MovieList

final class MovieListEndToEndTest: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {

        switch getResult() {
            case let .success(movieFeed)?:
                XCTAssertEqual(movieFeed.count, 20, "Expected 20 movie in the test account image feed")

            case .failure(let error)?:
                XCTFail("Expected successful feed result, get \(error) instead")

            default:
                XCTFail("Expected successful feed result, got no result instead")
        }

    }

    private func getResult(file: StaticString = #filePath, line: UInt = #line) -> NetworkMovieLoader.Result? {
        let testServerURL = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=7e588fae3312be4835d4fcf73918a95f&query=a%20&page=01")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = NetworkMovieLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        let exp = expectation(description: "Wait for response")

        var receivedResult: NetworkMovieLoader.Result?
        loader.load(url: testServerURL) { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10.0)
        return receivedResult
    }

    private func imageURL(at index: Int) -> URL {
        return URL(string: "https://url-\(index+1).com")!
    }

}

//
//  File.swift
//  MovieListTests
//
//  Created by Viral on 02/12/22.
//

import XCTest
import MovieList

extension RemoteMovieLoaderTests {
    func expect(_ sut: RemoteMovieLoader,
                toCompleteWith expectedResult: Result<[MovieFeed], RemoteMovieLoader.Error>,
                when action: () -> Void,
                file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

                case let (.failure(receivedError), .failure(expectedError)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)

                default:
                    XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        waitForExpectations(timeout: 0.1)
    }
}

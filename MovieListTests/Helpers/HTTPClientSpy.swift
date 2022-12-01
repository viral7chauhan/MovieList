//
//  HTTPClientSpy.swift
//  MovieListTests
//
//  Created by Viral on 02/12/22.
//

import Foundation
import MovieList

final class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()

    var requestedURLs: [URL] {
        messages.map(\.url)
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, completion))
    }

    func complete(with error: Error, at index: Int = 0,
                  file: StaticString = #filePath, line: UInt = #line) {
        messages[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0,
                  file: StaticString = #filePath, line: UInt = #line) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil)!

        messages[index].completion(.success((data, response)))
    }
}

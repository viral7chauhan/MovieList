//
//  HTTPClientSpy.swift
//  MovieListTests
//
//  Created by Viral on 09/12/22.
//

import Foundation
import MovieList

class HTTPClientSpy: HTTPClient {

    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() { callback () }
    }

    private var message = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    private(set) var cancelledURLs = [URL]()

    var requestedURLs: [URL] {
        message.map { $0.url }
    }

    @discardableResult
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        message.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
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

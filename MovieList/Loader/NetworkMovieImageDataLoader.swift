//
//  NetworkMovieImageDataLoader.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

final class NetworkMovieImageDataLoader: MovieImageDataLoader {

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private final class HTTPClientTaskWrapper: MovieImageDataLoaderTask {
        private var completion: ((MovieImageDataLoader.Result) -> Void)?

        var wrapped: HTTPClientTask?

        init(_ completion: @escaping (MovieImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: MovieImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (MovieImageDataLoader.Result) -> Void) -> MovieImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { (data, response) in
                    let isValidResponse = (response.statusCode == Self.isOK) && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
        }
        return task
    }

    private static let isOK = 200
}

//
//  URLSessionHTTPClient.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private var session: URLSession

    private struct UnexpectedValuesRepresentation: Error {}

    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapper: URLSessionTask

        func cancel() {
            wrapper.cancel()
        }
    }

    init(session: URLSession) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse  {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }

        task.resume()
        return URLSessionTaskWrapper(wrapper: task)
    }
}

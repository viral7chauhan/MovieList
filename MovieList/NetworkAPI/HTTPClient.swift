//
//  HTTPClient.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    @discardableResult
    func get(from url: URL,
             completion: @escaping (Result) -> Void) -> HTTPClientTask
}

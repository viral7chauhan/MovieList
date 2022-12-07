//
//  HTTPClient.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL,
             completion: @escaping (Result) -> Void)
}

//
//  MovieImageDataLoader.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

public protocol MovieImageDataLoaderTask {
    func cancel()
}

public protocol MovieImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> MovieImageDataLoaderTask
}

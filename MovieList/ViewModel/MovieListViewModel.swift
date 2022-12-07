//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

typealias Observer<T> = (T) -> Void

final class MovieListViewModel {

    private let loader: MovieLoader

    init(loader: MovieLoader) {
        self.loader = loader
    }

    var onMovieLoaded: Observer<[MovieFeed]>?

    func loadMovies() {
        loader.load { [weak self] result in
            if let movies = try? result.get() {
                self?.onMovieLoaded?(movies)
            }
        }
    }
}

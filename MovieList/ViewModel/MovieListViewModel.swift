//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

protocol MovieListActions {
    func didSelectItem(at index: Int)
    func loadNextPage()
}

typealias Observer<T> = (T) -> Void

final class MovieListViewModel {

    weak var flowCoordinator: MovieCoordinator?
    private let loader: MovieLoader

    init(loader: MovieLoader) {
        self.loader = loader
    }

    var title: String {
        return "Movies"
    }

    var onMovieLoaded: Observer<[MovieFeed]>?
    private var movies = [MovieFeed]()

    func loadMovies() {
        loader.load { [weak self] result in
            if let movies = try? result.get() {
                self?.movies += movies
                self?.onMovieLoaded?(movies)
            }
        }
    }
}

extension MovieListViewModel: MovieListActions {
    func didSelectItem(at index: Int) {
        flowCoordinator?.showMovieDetails(with: movies[index])
    }

    func loadNextPage() {

    }
}

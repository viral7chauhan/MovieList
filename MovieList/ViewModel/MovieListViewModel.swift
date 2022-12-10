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
    private var page: Int = 1 {
        didSet {
            print("Request for page \(page)")
        }
    }

    init(loader: MovieLoader) {
        self.loader = loader
    }

    var title: String {
        return "Movies"
    }

    var onMovieLoaded: Observer<[MovieFeed]>?
    private var movies = [MovieFeed]()

    func loadMovies() {
        loader.load(url: movieURL) { [weak self, page] result in
            if let movies = try? result.get() {
                self?.movies += movies
                self?.onMovieLoaded?(movies)
                print("Loaded \(movies.count) movies for Page no - \(page)")
            }
        }
    }

    private var movieURL: URL {
        URL(string: "http://api.themoviedb.org/3/search/movie?api_key=7e588fae3312be4835d4fcf73918a95f&query=a%20&page=\(page)")!
    }
}

extension MovieListViewModel: MovieListActions {
    func didSelectItem(at index: Int) {
        flowCoordinator?.showMovieDetails(with: movies[index])
    }

    func loadNextPage() {
        page += 1
        loadMovies()
    }
}

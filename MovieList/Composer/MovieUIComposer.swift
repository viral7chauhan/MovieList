//
//  MovieUIComposer.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation
import UIKit

final class MovieUIComposer {

    private init() {}

    static func movieComposeWith(loader: MovieLoader, imageLoader: MovieImageDataLoader, flow: MovieCoordinator)
    -> MovieListViewController {

        let movieViewModel = MovieListViewModel(loader: loader)
        movieViewModel.flowCoordinator = flow

        let movieController = makeMovieListController(with: movieViewModel)

        movieViewModel.onMovieLoaded = adaptFeedToCellController(forwardingTo: movieController, loader: imageLoader)

        return movieController
    }

    private static func adaptFeedToCellController(forwardingTo controller: MovieListViewController,
                                                  loader: MovieImageDataLoader) -> ([MovieFeed]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel += feed.map { model in
                MovieImageCellController(
                    viewModel: MovieImageViewModel(model: model,imageLoader: loader))
            }
        }
    }

    private static func makeMovieListController(with viewModel: MovieListViewModel) -> MovieListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieController = storyboard.instantiateInitialViewController() as! MovieListViewController
        movieController.viewModel = viewModel
        return movieController
    }

    static func makeMovieDetailsController(with viewModel: MovieImageViewModel) -> MovieDetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailsController = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsController.viewModel = viewModel
        return movieDetailsController
    }
}

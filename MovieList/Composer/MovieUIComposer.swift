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

    static func movieComposeWith(loader: MovieLoader, imageLoader: MovieImageDataLoader)
    -> MovieListViewController {

        let movieViewModel = MovieListViewModel(loader: loader)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieController = storyboard.instantiateInitialViewController() as! MovieListViewController
        movieController.viewModel = movieViewModel
        movieViewModel.onMovieLoaded = adaptFeedToCellController(forwardingTo: movieController, loader: imageLoader)

        return movieController
    }

    private static func adaptFeedToCellController(forwardingTo controller: MovieListViewController,
                                          loader: MovieImageDataLoader) -> ([MovieFeed]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                MovieImageCellController(viewModel: MovieImageViewModel(model: model,
                                                                      imageLoader: loader))
            }
        }
    }

}

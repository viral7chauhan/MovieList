//
//  MovieImageViewModel.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

final class MovieImageViewModel {

    private var task: MovieImageDataLoaderTask?
    private var model: MovieFeed
    private let imageLoader: MovieImageDataLoader

    init(task: MovieImageDataLoaderTask? = nil, model: MovieFeed, imageLoader: MovieImageDataLoader) {
        self.task = task
        self.model = model
        self.imageLoader = imageLoader
    }

    var title: String { model.title }
    var overview: String { model.overview }
    
}

//
//  MovieImageViewModel.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation
import UIKit

final class MovieImageViewModel {

    private let imageBaseURL = "http://image.tmdb.org/t/p/w92/"
    
    private var task: MovieImageDataLoaderTask?
    private var model: MovieFeed
    private let imageLoader: MovieImageDataLoader

    init(task: MovieImageDataLoaderTask? = nil, model: MovieFeed, imageLoader: MovieImageDataLoader) {
        self.task = task
        self.model = model
        self.imageLoader = imageLoader
    }

    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    var title: String { model.title }
    var overview: String { model.overview }
    var releaseDate: String { dateFormatter.string(from: model.releaseDate) }

    var onImageLoad: Observer<UIImage>?

    func loadImageData() {
        task = imageLoader.loadImageData(from: imageURL) { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: MovieImageDataLoader.Result) {
        if let data = (try? result.get()),
           let image = UIImage(data: data) {
            onImageLoad?(image)
        }
    }

    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }

    private var imageURL: URL {
        if let url = URL(string: imageBaseURL + model.thumbnailImage) {
            return url
        }
        fatalError("Invalid Image url")
    }

}

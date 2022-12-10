//
//  MovieImageViewModel.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation
import UIKit

final class MovieImageViewModel {

    enum ImageResolution {
        case low
        case high

        var url: String {
            var baseURL = "http://image.tmdb.org/t/p"
            switch self {
                case .low: baseURL += "/w92/"
                case .high: baseURL += "/w500/"
            }
            return baseURL
        }
    }
    
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

    func loadImageData(with resolution: ImageResolution = .low) {
        task = imageLoader.loadImageData(from: imageURL(for: resolution)) { [weak self] result in
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

    private func imageURL(for resolution: ImageResolution) -> URL {
        if let url = URL(string: resolution.url + model.thumbnailImage) {
            return url
        }
        fatalError("Invalid Image url")
    }
}

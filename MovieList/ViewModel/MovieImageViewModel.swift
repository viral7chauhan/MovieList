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

    var updatedItem: ((MovieFeed) -> Void)?

    private var task: MovieImageDataLoaderTask?
    var model: MovieFeed
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

    var isWatchListItem:  UIImage {
        let imgName = isAddedInWatchList ? "star.fill" : "star"
        return UIImage(systemName: imgName)!
    }
    
    var title: String { model.title }
    var overview: String { model.overview }
    var releaseDate: String { dateFormatter.string(from: model.releaseDate) }
    var isAddedInWatchList: Bool { model.isFavorite }

    var onImageLoad: Observer<UIImage>?
    var onWatchItemUpdate: Observer<Bool>?

    func loadImageData(with resolution: ImageResolution = .low) {
        guard let url = imageURL(for: resolution) else {
            print("Image url not found")
            return
        }
        task = imageLoader.loadImageData(from: url) { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: MovieImageDataLoader.Result) {
        if let data = (try? result.get()),
           let image = UIImage(data: data) {
            onImageLoad?(image)
        }
    }

    func onWatchListChange() {
        model.isFavorite = !model.isFavorite
        onWatchItemUpdate?(model.isFavorite)
        updatedItem?(model)
    }

    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }

    private func imageURL(for resolution: ImageResolution) -> URL? {
        if let url = model.bannerImage {
            return URL(string: resolution.url + url)
        }
        return nil
    }


}

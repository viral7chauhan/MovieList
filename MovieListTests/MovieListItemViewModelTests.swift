//
//  MovieListItemViewModelTests.swift
//  MovieListTests
//
//  Created by Viral on 11/12/22.
//

import XCTest
import MovieList

private class LoaderSpy: MovieImageDataLoader {

    var requestedURLs: [URL] {
        message.map (\.url)
    }

    private var message = [(url: URL, completion: (MovieImageDataLoader.Result) -> Void)]()
    private(set) var cancelledURLs = [URL]()

    private struct Task: MovieImageDataLoaderTask {
        var completion: () -> Void

        func cancel() {
             completion()
        }
    }

    func loadImageData(from url: URL, completion: @escaping (MovieImageDataLoader.Result) -> Void) -> MovieImageDataLoaderTask {
        message.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }
}

final class MovieListItemViewModelTests: XCTestCase {

    func test_init_doesNotStartLoadingOnInit() {
        let (_ , loader) = makeSUT()

        XCTAssertTrue(loader.requestedURLs.isEmpty)
    }

    func test_load_loadImageDataOnCall() {
        let (sut, loader) = makeSUT()

        sut.loadImageData()

        XCTAssertEqual(loader.requestedURLs.count, 1)
    }

    func test_load_loadRequestCancellation() {
        let (sut, loader) = makeSUT()

        sut.loadImageData()
        sut.cancelImageDataLoad()

        XCTAssertEqual(loader.cancelledURLs.count, 1)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: MovieImageViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let viewModel = MovieImageViewModel(model: makeFeed(), imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(viewModel, file: file, line: line)
        return (viewModel, loader)
    }

    private func makeFeed() -> MovieFeed {
        MovieFeed(id: 3, title: "A Movie", originalTitle: "A origianl Title", thumbnailImage: "adadfads.jpg", bannerImage: "adfadf.jpg", overview: "This is awesome movie", popularity: 4.5, releaseDate: Date(), voteCount: 5, isFavorite: false)
    }
}

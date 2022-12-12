//
//  MovieListViewModelTests.swift
//  MovieListTests
//
//  Created by Viral on 11/12/22.
//

import XCTest
import MovieList

private class LoaderSpy: MovieLoader {
    var requestedURLs: [URL] {
        message.map(\.url)
    }

    private var message = [(url: URL, completion: (MovieLoader.Result) -> Void)]()

    func load(url: URL, _ completion: @escaping (MovieLoader.Result) -> Void) {

        message.append((url, completion))
    }
}


final class MovieListViewModelTests: XCTestCase {
    
    func test_init_doesNotStartLoading() {
        let (_, loader) = makeSUT()

        XCTAssertTrue(loader.requestedURLs.isEmpty)
    }

    func test_load_initialLoadCalledPage1() {
        let (sut, loader) = makeSUT()

        sut.loadMovies()

        XCTAssertEqual(loader.requestedURLs.count, 1)
        XCTAssertEqual(sut.page, 1)
    }

    func test_load_loadNextPage() {
        let (sut, loader) = makeSUT()

        sut.loadMovies()

        XCTAssertEqual(loader.requestedURLs.count, 1)
        XCTAssertEqual(sut.page, 1)

        sut.loadNextPage()
        XCTAssertEqual(loader.requestedURLs.count, 2)
        XCTAssertEqual(sut.page, 2)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: MovieListViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = MovieListViewModel(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

}

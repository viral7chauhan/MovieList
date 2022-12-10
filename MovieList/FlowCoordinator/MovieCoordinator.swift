//
//  MovieCoordinator.swift
//  MovieList
//
//  Created by Viral on 09/12/22.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}


class MovieCoordinator: Coordinator {

    lazy var urlSessionClient: HTTPClient = {
        let client = URLSessionHTTPClient(session: .shared)
        return client
    }()

    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        print(navigationController.viewControllers)
    }

    func setFirstController(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: false)
    }

    func showMovieDetails(with movie: MovieFeed) {

        let url = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=7e588fae3312be4835d4fcf73918a95f&query=a%20&page=01")!
        let movieImageLoader = NetworkMovieImageDataLoader(client: urlSessionClient)
        let viewModel = MovieImageViewModel(model: movie, imageLoader: movieImageLoader)
        let controller = MovieUIComposer.makeMovieDetailsController(with: viewModel)

        navigationController.pushViewController(controller, animated: true)
    }

}

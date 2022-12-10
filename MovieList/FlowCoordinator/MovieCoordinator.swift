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

    func showMovieDetails(with movie: MovieFeed, _ updated: @escaping (MovieFeed) -> Void) {
        let movieImageLoader = NetworkMovieImageDataLoader(client: urlSessionClient)
        let viewModel = MovieImageViewModel(model: movie, imageLoader: movieImageLoader)
        viewModel.updatedItem = updated
        let controller = MovieUIComposer.makeMovieDetailsController(with: viewModel)

        navigationController.pushViewController(controller, animated: true)
    }

}

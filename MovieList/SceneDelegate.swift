//
//  SceneDelegate.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var movieCoordinator: MovieCoordinator?

    var window: UIWindow?
    lazy var urlSessionClient: HTTPClient = {
        let client = URLSessionHTTPClient(session: .shared)
        return client
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindw()
        window?.makeKeyAndVisible()
    }

    func configureWindw() {

        let movieLoader = NetworkMovieLoader(client: urlSessionClient)
        let movieImageLoader = NetworkMovieImageDataLoader(client: urlSessionClient)

        let navigation = UINavigationController()
        movieCoordinator = MovieCoordinator(navigationController: navigation)

        let movieListController = MovieUIComposer.movieComposeWith(
            loader: movieLoader,
            imageLoader: movieImageLoader,
            flow: movieCoordinator!)


        movieCoordinator?.setFirstController(movieListController)

        window?.rootViewController = navigation
    }
}


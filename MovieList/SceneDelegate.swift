//
//  SceneDelegate.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

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
        let url = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=7e588fae3312be4835d4fcf73918a95f&query=a%20&page=01")!

        let movieLoader = NetworkMovieLoader(url: url, client: urlSessionClient)
        let movieImageLoader = NetworkMovieImageDataLoader(client: urlSessionClient)


        window?.rootViewController = UINavigationController(
            rootViewController: MovieUIComposer.movieComposeWith(
                loader: movieLoader,
                imageLoader: movieImageLoader)) 
    }


}


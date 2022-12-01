//
//  RemoteMovieLoader.swift
//  MovieList
//
//  Created by Viral on 01/12/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}

public final class RemoteMovieLoader {
    private let client: HTTPClient
    private let url: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = Swift.Result<[MovieFeed], Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(_ completion: @escaping (RemoteMovieLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                completion(RemoteMovieMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

enum RemoteMovieMapper {

    private struct Root: Decodable {
        var page: Int
        var results: [MovieItem]

        struct MovieItem: Decodable {
            let id: UUID
            let title: String
            let originalTitle: String
            let thumbnailImage: String
            let bannerImage: String
            let overview: String
            let popularity: Double
            let releaseDate: Date
            let voteCount: Int

            private enum CodingKeys: String, CodingKey {
                case id = "id"
                case title = "title"
                case originalTitle = "original_title"
                case thumbnailImage = "backdrop_path"
                case bannerImage = "poster_path"
                case overview = "overview"
                case popularity = "popularity"
                case releaseDate = "release_date"
                case voteCount = "vote_count"
            }

            var feed: MovieFeed {
                MovieFeed(id: id, title: title, originalTitle: originalTitle, thumbnailImage: thumbnailImage, bannerImage: bannerImage, overview: overview, popularity: popularity, releaseDate: releaseDate, voteCount: voteCount, isFavorite: false)
            }
        }

        var movieFeeds: [MovieFeed] {
            results.map(\.feed)
        }

    }
    private static let isOK = 200

    static func map(data: Data, response: HTTPURLResponse) -> RemoteMovieLoader.Result {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard response.statusCode == isOK,
              let root = try? decoder.decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }

        return .success(root.movieFeeds)
    }
}

//
//  MovieFeedMapper.swift
//  MovieList
//
//  Created by Viral on 07/12/22.
//

import Foundation

enum MovieFeedItemMapper {
    private struct Root: Decodable {
        var page: Int
        var results: [MovieItem]

        struct MovieItem: Decodable {
            let id: Int
            let title: String
            let originalTitle: String
            let thumbnailImage: String?
            let bannerImage: String?
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

    static func map(_ data: Data, from response: HTTPURLResponse) -> MovieLoader.Result {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        guard response.statusCode == isOK else {
            return .failure(NetworkMovieLoader.Error.invalidData)
        }

        do {
            let root = try decoder.decode(Root.self, from: data)
            return .success(root.movieFeeds)
        } catch {
            print(error.localizedDescription)
            return .failure(NetworkMovieLoader.Error.invalidData)
        }


    }
}

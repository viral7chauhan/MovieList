//
//  MovieFeed.swift
//  MovieList
//
//  Created by Viral on 01/12/22.
//

import Foundation

public struct MovieFeed: Hashable {
    public let id: UUID
    public let title: String
    public let originalTitle: String
    public let thumbnailImage: String
    public let bannerImage: String
    public let overview: String
    public let popularity: Double
    public let releaseDate: Date
    public let voteCount: Int
    public var isFavorite: Bool

    public init(id: UUID, title: String, originalTitle: String, thumbnailImage: String, bannerImage: String, overview: String, popularity: Double, releaseDate: Date, voteCount: Int, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.thumbnailImage = thumbnailImage
        self.bannerImage = bannerImage
        self.overview = overview
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.voteCount = voteCount
        self.isFavorite = isFavorite
    }
}

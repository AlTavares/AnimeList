//
//  Episode.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 05/02/19.
//

import Foundation

struct Episode: Codable {
    let id, type: String
    let links: EpisodeLinks
    let attributes: EpisodeAttributes
    let relationships: Relationships
}

struct EpisodeAttributes: Codable {
    let createdAt, updatedAt: String
    let titles: EpisodeTitles
    let canonicalTitle: String
    let seasonNumber, number, relativeNumber: Int
    let synopsis, airdate: String
    let length: Int
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let original: URL
}

struct EpisodeTitles: Codable {
    let enJp, enUs, jaJp: String?

    enum CodingKeys: String, CodingKey {
        case enJp = "en_jp"
        case enUs = "en_us"
        case jaJp = "ja_jp"
    }
}

struct EpisodeLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

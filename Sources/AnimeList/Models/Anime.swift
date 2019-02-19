//
//  Anime.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 05/02/19.
//

import Foundation

struct Anime: Codable {
    let id, type: String
    let links: EpisodeLinks
    let attributes: AnimeAttributes
    let relationships: [String: Relationship]
}

struct AnimeAttributes: Codable {
    let slug, synopsis: String
    let titles: AnimeTitles
    let canonicalTitle: String
    let averageRating: String?
    let startDate: String?
    let endDate: String?
    let subtype, status: String?
    let posterImage: ImageDimensions?
    let coverImage: ImageDimensions?
    let episodeCount: Int?
    let youtubeVideoId, showType: String?
    let nsfw: Bool

    var year: String? {
        guard let startDate = startDate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: startDate) else { return nil }
        return String(Calendar.current.component(.year, from: date))
    }
}

struct AnimeTitles: Codable {
    let en, enJp, jaJp: String?

    enum CodingKeys: String, CodingKey {
        case en
        case enJp = "en_jp"
        case jaJp = "ja_jp"
    }
}

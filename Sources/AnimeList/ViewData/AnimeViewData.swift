//
//  AnimeViewData.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 17/02/19.
//

import Foundation

struct AnimeViewData: CustomStringConvertible {
    var id: String {
        return anime.id
    }

    var name: String {
        return anime.attributes.canonicalTitle
    }

    var posterUrl: URL? {
        return anime.attributes.posterImage?.original
    }

    private let defaultCoverUrl = URL(string: "https://kitsu.io/images/default_cover-7bda2081d0823731a96bbb20b70f4fcf.png")
    var coverUrl: URL? {
        return anime.attributes.coverImage?.original ?? defaultCoverUrl
    }

    var year: String? {
        return anime.attributes.year
    }

    var synopsis: String {
        return anime.attributes.synopsis
    }

    var description: String {
        return "\(id) - \(name) \(year ?? "")"
    }

    private let anime: Anime
    init(anime: Anime) {
        self.anime = anime
    }
}

extension AnimeItemViewData {
    init(item: AnimeViewData) {
        self.id = item.id
        self.imageUrl = item.posterUrl
        self.title = item.name
        self.subtitle = item.year
    }
}

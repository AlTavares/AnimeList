//
//  EpisodeViewData.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 17/02/19.
//

import Foundation

struct EpisodeViewData: CustomStringConvertible {
    var id: String {
        return episode.id
    }

    var name: String {
        return "Episode \(episode.attributes.number)"
    }

    var title: String {
        return episode.attributes.canonicalTitle
    }

    var imageURL: URL {
        return episode.attributes.thumbnail.original
    }

    var synopsis: String {
        return episode.attributes.synopsis
    }

    var description: String {
        return "\(id) - \(name): \(title)"
    }

    private let episode: Episode
    init(episode: Episode) {
        self.episode = episode
    }
}

extension AnimeItemViewData {
    init(item: EpisodeViewData) {
        id = item.id
        imageUrl = item.imageURL
        title = item.title
        subtitle = item.name
    }
}

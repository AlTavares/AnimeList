//
//  DeepLink.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 17/02/19.
//

import Foundation

public enum DeepLink {
    case anime(id: String)
    case episode(animeId: String, id: String)
}

class DeepLinkParser {
    func parse(_ value: String) -> DeepLink? {
        let values = value.split(separator: "/").map(String.init)
        if let animeId = id(for: "anime", from: values) {
            if let episodeId = id(for: "episode", from: values) {
                return DeepLink.episode(animeId: animeId, id: episodeId)
            }
            return DeepLink.anime(id: animeId)
        }
        return nil
    }

    private func id(for key: String, from values: [String]) -> String? {
        guard let index = values.firstIndex(of: key), values.count > index + 1 else { return nil }
        return values[index + 1]
    }
}

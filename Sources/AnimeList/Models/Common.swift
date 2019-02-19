//
//  Common.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 05/02/19.
//

import Foundation

struct Relationships: Codable {
    let media, videos: Media
}

struct Media: Codable {
    let links: MediaLinks
}

struct MediaLinks: Codable {
    let related: String
}

struct ImageDimensions: Codable {
    let tiny, small, medium, large, original: URL?
}

struct Relationship: Codable {
    let links: RelationshipLinks
}

struct RelationshipLinks: Codable {
    let related: URL
}

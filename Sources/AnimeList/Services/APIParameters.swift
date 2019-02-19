//
//  APIParameters.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 06/02/19.
//

import Foundation

public protocol APIParameter {
    var parameters: [String: Encodable] { get }
}

public struct Page: APIParameter {
    public var limit: Int
    public var offset: Int

    public var parameters: [String: Encodable] {
        return [
            "page": [
                "limit": limit,
                "offset": offset
            ]
        ]
    }
}

public struct Filter: APIParameter {
    public enum Status: String {
        case current
        case upcoming
    }

    public var status: Status?
    public var mediaId: String?

    init(status: Status? = nil, mediaId: String? = nil) {
        self.status = status
        self.mediaId = mediaId
    }

    public var parameters: [String: Encodable] {
        return [
            "filter": [
                "status": status?.rawValue,
                "media_id": mediaId
            ].filter { $0.value != nil }
        ]
    }
}

public struct Sort: APIParameter {
    public enum Field: String {
        case userCount = "user_count"
        case averageRating = "average_rating"
        case number
    }

    public enum Order: String {
        case increasing = ""
        case decreasing = "-"
    }

    public var sortField: Field
    public var order: Order

    public var parameters: [String: Encodable] {
        return [
            "sort": "\(order.rawValue)\(sortField.rawValue)"
        ]
    }
}

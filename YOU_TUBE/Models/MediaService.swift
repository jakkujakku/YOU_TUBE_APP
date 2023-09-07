//
//  MediaService.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import Foundation

class DataManager {
    static let shared = DataManager()

    var thumbnailInfo: ThumbnailInfo?
}

struct ThumbnailInfo: Codable {
    let kind: String
    let etag: String
    let items: [Items]
    let pageInfo: PageInfo

    enum CodingKeys: String, CodingKey {
        case kind
        case etag
        case items
        case pageInfo
    }
}

struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct Items: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: Snippet
    let statistics: Statistics
}

struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let descriptions: String?
    let thumbnails: Thumbnails
    let channelTitle: String
    let categoryId: String
    let liveBroadcastContent: String
    let localized: Localized
}

struct Thumbnails: Codable {
    let `default`: Default
    let medium: Medium
    let high: High
    let standard: Standard
    let maxres: Max?
}

struct Default: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct Medium: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct High: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct Standard: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct Max: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct Localized: Codable {
    let title: String
    let description: String
}

struct Statistics: Codable {
    let viewCount: String
    let likeCount: String
    let favoriteCount: String
    let commentCount: String
}

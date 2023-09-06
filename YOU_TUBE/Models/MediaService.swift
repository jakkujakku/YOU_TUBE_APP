//
//  MediaService.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import Foundation

struct ThumbnailInfo: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String
    let regionCode: String
    let pageInfo: PageInfo
    var items: [Items]

    enum CodingKeys: String, CodingKey {
        case kind
        case etag
        case nextPageToken
        case regionCode
        case pageInfo
        case items
    }
}

struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct Items: Codable {
    let kind: String
    let etag: String
    let id: IdInfo
    let snippet: Snippet
}

struct IdInfo: Codable {
    let kind: String
}

struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let descriptions: String?
    let thumbnails: Thumbnails
    let channelTitle: String
    let liveBroadcastContent: String
    let publishTime: String
}

struct Thumbnails: Codable {
    let `default`: Default
    let medium: Medium
    let high: High

    enum CodingKeys: String, CodingKey {
        case `default`
        case medium
        case high
    }
}

struct Default: Codable {
    let url: String
}

struct Medium: Codable {
    let url: String
}

struct High: Codable {
    let url: String
}

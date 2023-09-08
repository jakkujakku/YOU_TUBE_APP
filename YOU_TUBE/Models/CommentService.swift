//
//  CommentService.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

struct CommentStruct {
    
    static var postNumber = 0
    let postnumber: Int
    let userId: String
    let userImage: UIImage
    let date = Date()
    let comment: String
    
    init(userId: String, userImage: UIImage, comment: String) {
        postnumber = CommentStruct.postNumber
        self.userId = userId
        self.userImage = userImage
        self.comment = comment
        CommentStruct.postNumber += 1
    }
    
}

// MARK: - Welcome
struct CommentService2: Codable {
//    let kind, etag, nextPageToken: String
    let items: [Item]
    
//    enum CodingKeys: String, CodingKey {
//        case kind, etag, nextPageToken
//        case items
//
//    }
}

// MARK: - Item
struct Item: Codable {
//    let kind, etag, id: String
    let snippet: ItemSnippet
    let replies: Replies?
}

// MARK: - Replies
struct Replies: Codable {
    let comments: [Comment]
}

// MARK: - Comment
struct Comment: Codable {
//    let kind, etag, id: String
    let snippet: TopLevelCommentSnippet
}

// MARK: - TopLevelCommentSnippet
struct TopLevelCommentSnippet: Codable {
    let channelID, videoID, textDisplay, textOriginal: String
    let parentID: String?
    let authorDisplayName: String
    let authorProfileImageURL: String
    let authorChannelURL: String
//    let authorChannelID: AuthorChannelID
//    let canRate: Bool
//    let viewerRating: String
//    let likeCount: Int
//    let publishedAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case channelID = "channelId"
        case videoID = "videoId"
        case textDisplay, textOriginal
        case parentID = "parentId"
        case authorDisplayName
        case authorProfileImageURL = "authorProfileImageUrl"
        case authorChannelURL = "authorChannelUrl"
//        case authorChannelID = "authorChannelId"
//        case canRate
//        case viewerRating
//        case likeCount
//        case publishedAt
        case updatedAt
    }
}

//// MARK: - AuthorChannelID
//struct AuthorChannelID: Codable {
//    let value: String
//}

//// MARK: - ItemSnippet
struct ItemSnippet: Codable {
//    let channelID, videoID: String
    let topLevelComment: Comment
//    let canReply: Bool
//    let totalReplyCount: Int
//    let isPublic: Bool

//    enum CodingKeys: String, CodingKey {
//        case channelID = "channelId"
//        case videoID = "videoId"
//        case topLevelComment
//        case canReply, totalReplyCount, isPublic
//    }
}



// MARK: - 코멘트 네트워킹 싱글톤

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

final class CommentNetworking {
    
    //싱글톤
    static let shared = CommentNetworking()
    
    private init() {}
    
    //Result 타입
    typealias NetworkCompletion = (Result<CommentService2, NetworkError>) -> Void
    
    func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        print(#function)
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            print(safeData.description)
            let result = String(data: safeData, encoding: .utf8)
            print(result)
//                         데이터 분석하기
            if let commentData = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(commentData))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
            
//            do {
//                // make sure this JSON is in the format we expect
//                if let dictionary = try JSONSerialization.jsonObject(with: safeData, options: .fragmentsAllowed) as? [String: Any] {
//                    let items = dictionary["items"] as? [Any]
//
//                }
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
//

        }
        task.resume()
    }
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parseJSON(_ data: Data) -> CommentService2? {
        print(#function)
        // 성공
        do {
            let decoder = JSONDecoder()
            let commentdata = try decoder.decode(CommentService2.self, from: data)
            return commentdata
            // 실패
        } catch {
            print("decode 실패")
            print(error.localizedDescription)
            return nil
        }
    }
    
}

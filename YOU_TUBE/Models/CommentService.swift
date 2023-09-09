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
    let items: [Item]
}

// MARK: - Item

struct Item: Codable {
    let snippet: ItemSnippet?
}

//// MARK: - ItemSnippet
struct ItemSnippet: Codable {
    let topLevelComment: Comment
}

// MARK: - Comment

struct Comment: Codable {
    let snippet: TopLevelCommentSnippet
}

// MARK: - TopLevelCommentSnippet

struct TopLevelCommentSnippet: Codable {
    let textOriginal: String?
    let authorDisplayName: String
    let authorProfileImageURL: String?
    let likeCount: Int
    let publishedAt: String

    enum CodingKeys: String, CodingKey {
        case textOriginal
        case authorDisplayName
        case authorProfileImageURL = "authorProfileImageUrl"
        case likeCount
        case publishedAt
    }
}

// MARK: - 코멘트 네트워킹 싱글톤

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

final class CommentNetworking {
    // 싱글톤
    static let shared = CommentNetworking()

    private init() {}

    // Result 타입
    typealias NetworkCompletion = (Result<CommentService2, NetworkError>) -> Void

    func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        print(#function)
        guard let url = URL(string: urlString) else { return }

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }

            if let commentData = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(commentData))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
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

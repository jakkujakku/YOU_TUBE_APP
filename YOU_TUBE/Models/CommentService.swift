//
//  CommentService.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

struct Comment {
    
    static var postNumber = 0
    let postnumber: Int
    let userId: String
    let userImage: UIImage
    let date = Date()
    let comment: String
    
    init(userId: String, userImage: UIImage, comment: String) {
        postnumber = Comment.postNumber
        self.userId = userId
        self.userImage = userImage
        self.comment = comment
        Comment.postNumber += 1
    }
    
    
}

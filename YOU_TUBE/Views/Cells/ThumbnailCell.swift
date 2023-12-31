//
//  ThumbnailCell.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

final class ThumbnailCell: UICollectionViewCell {
    static let identifier = "ThumbnailCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
}

//
//  DetailPageTableViewCell.swift
//  YOU_TUBE
//
//  Created by 천광조 on 2023/09/04.
//

import UIKit

class DetailPageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var commentUserImage: UIImageView!
    
    @IBOutlet weak var commentUserName: UILabel!
    
    @IBOutlet weak var postedCommentDate: UILabel!
    
    @IBOutlet weak var comment: UILabel!
    
    
    @IBOutlet weak var toSeeMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    @IBAction func toSeeMoreButtonTapped(_ sender: UIButton) {
    }
    
    
    
}

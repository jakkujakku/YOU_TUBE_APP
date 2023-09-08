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
    
    var imageData: String?
    
    private var isTextExpanded = false
    
    @IBOutlet weak var toSeeMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let imageData = imageData else { return }
        commentUserImage.layer.cornerRadius = commentUserImage.frame.height / 2
        commentUserImage.clipsToBounds = true
        loadImage(url: imageData)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    @IBAction func toSeeMoreButtonTapped(_ sender: UIButton) {
        isTextExpanded.toggle()
        
        if isTextExpanded {
            comment.numberOfLines = 0
            toSeeMoreButton.setTitle("접기", for: .normal)
        } else {
            comment.numberOfLines = 3
            toSeeMoreButton.setTitle("...더보기", for: .normal)
        }
        
    }
    
    
    private func loadImage(url: String) {
            guard let url = URL(string: url)  else { return }
            
            DispatchQueue.global().async {
            
                guard let data = try? Data(contentsOf: url) else { return }

                DispatchQueue.main.async {
                    self.commentUserImage.image = UIImage(data: data)
                }
            }
        }
 
}

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
    
    
    private var isTextExpanded = true
    
    @IBOutlet weak var toSeeMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    @IBAction func toSeeMoreButtonTapped(_ sender: UIButton) {
    
        let currentNumberOfLines = comment.numberOfLines

            if isTextExpanded {
                // 현재 상태가 확장된 상태일 때
                if currentNumberOfLines > 2 {
                    // 현재 라인 수가 2보다 크다면 줄이기
                    comment.numberOfLines = 2
                    toSeeMoreButton.setTitle("...더보기", for: .normal)
                } else {
                    // 현재 라인 수가 2 이하라면 텍스트 접기
                    comment.numberOfLines = 0
                    toSeeMoreButton.setTitle("접기", for: .normal)
                }
            } else {
                // 현재 상태가 접혀있는 상태일 때
                comment.numberOfLines += 1 // 라인 수 증가
                toSeeMoreButton.setTitle("...더보기", for: .normal)
                }
                
        if currentNumberOfLines == 1 {
            // 현재 라인 수가 1이면 (한 줄에서 더보기로 전환)
            toSeeMoreButton.setTitle("접기", for: .normal)
                
            }

            // 버튼 상태 토글
            isTextExpanded.toggle()
    }

}

//
//  ProfileCell.swift
//  YOU_TUBE
//
//  Created by t2023-m0053 on 2023/09/07.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()

        // 이미지와 텍스트의 정렬 설정
        profileImageView.contentMode = .scaleAspectFit // 이미지를 셀 내에서 비율을 유지하며 맞춤
        profileImageView.clipsToBounds = true // 이미지가 셀을 넘어갈 경우 잘라냄

        profileLabel.textAlignment = .left // 텍스트를 왼쪽으로 정렬
        profileLabel.font = UIFont.systemFont(ofSize: 16) // 텍스트의 폰트 설정 (원하는 폰트 및 크기로 변경)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

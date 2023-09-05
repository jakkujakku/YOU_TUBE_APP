//
//  ProfileController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var ProfileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    @IBAction func Membership(_ sender: UIButton) {
        // alert (제목, 메시지, alert종류) 지정
        let alert = UIAlertController(title: "회원삭제", message: "회원삭제 하시겠습니까?", preferredStyle: .alert)
        // 확인 버튼
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        // 취소 버튼
        let close = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        // alert (제목, 메시지, alert종류) 지정
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        // 확인 버튼
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        // 취소 버튼
        let close = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
}

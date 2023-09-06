//
//  ProfileController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // 데이터 전달 받기
        if let imageData = UserDefaults.standard.data(forKey: "Image") {
            if let image = UIImage(data: imageData) {
                profileImageView.image = image
            }
        }

        if let name = UserDefaults.standard.string(forKey: "Name") {
            nameTextField.text = name
        }

        if let email = UserDefaults.standard.string(forKey: "Email") {
            emailTextField.text = email
        }

        // NotificationCenter로부터의 데이터 변경 알림 처리
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileDataUpdated), name:
            NSNotification.Name("ProfileDataUpdated"), object: nil)
    }

    @objc private func handleProfileDataUpdated() {
        // 프로필 정보 업데이트 로직 (UserDefaults로부터 다시 불러옴)
        if let imageData = UserDefaults.standard.data(forKey: "Image") {
            if let image = UIImage(data: imageData) {
                profileImageView.image = image
            }
        }

        if let name = UserDefaults.standard.string(forKey: "Name") {
            nameTextField.text = name
        }

        if let email = UserDefaults.standard.string(forKey: "Email") {
            emailTextField.text = email
        }
    }

    deinit {
        // Notification Observer 해제 (메모리 누수 방지)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func memberShip(_ sender: UIButton) {
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

    @IBAction func logoutButton(_ sender: Any) {
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

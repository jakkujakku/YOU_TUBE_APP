//
//  ProfileController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // 셀 수정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! ProfileCell
        cell.profileLabel.text = profile[indexPath.row]
        cell.profileImageView.image = UIImage(named: profileImages[indexPath.row])

        return cell // 셀 설정
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear // 셀 투명도 설정
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // 셀의 높이를 60으로 설정
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // 섹션 헤더의 높이를 10으로 설정
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView // 섹션 헤더에 배경색을 없애기 위해 빈 UIView 반환
    }

    let profile = ["내 채널", "Youtube 스튜디오", "내 Premium 혜택", "위치: 한국", "설정", "고객센터", "의견 보내기"]
    let profileImages = ["person", "studio", "premium", "world", "setup", "helpcenter", "comments"]

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deletingUserButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.dataSource = self
        profileTableView.delegate = self
        view.backgroundColor = .systemBackground
        // 데이터 전달 받기
        updateUIWithStoredData()
        NotificationCenter.default.addObserver(self,
                                               selector:
                                               #selector(updateUIWithStoredData),
                                               name:
                                               NSNotification.Name("ProfileDataUpdated"),
                                               object:
                                               nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.isNavigationBarHidden = true
    }

    @objc private func updateUIWithStoredData() {
        if let imageData = UserDefaults.standard.data(forKey:
            "Image")
        {
            if let image = UIImage(data:
                imageData)
            {
                profileImageView.image = image
            }
        }
        if let name =
            UserDefaults.standard.string(forKey: "Name")
        {
            nameLabel.text = name
        }
        if let email =
            UserDefaults.standard.string(forKey: "Email")
        {
            emailLabel.text = email
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // 다크모드 텍스트필드 및 버튼 즉각 대응
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                nameLabel.textColor = UIColor.white
                emailLabel.textColor = UIColor.white
                logoutButton.setTitleColor(UIColor.white, for: .normal)
                deletingUserButton.setTitleColor(UIColor.white, for: .normal)
                editButton.setTitleColor(UIColor.white, for: .normal)

            } else {
                nameLabel.textColor = UIColor.black
                emailLabel.textColor = UIColor.black
                logoutButton.setTitleColor(UIColor.black, for: .normal)
                deletingUserButton.setTitleColor(UIColor.black, for: .normal)
                editButton.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }

    @objc private func handleProfileDataUpdated() {
        // 프로필 정보 업데이트 로직 (UserDefaults로부터 다시 불러옴)
        if let imageData = UserDefaults.standard.data(forKey: "Image") {
            if let image = UIImage(data: imageData) {
                profileImageView.image = image
            }
        }

        if let name = UserDefaults.standard.string(forKey: "Name") {
            nameLabel.text = name
        }

        if let email = UserDefaults.standard.string(forKey: "Email") {
            emailLabel.text = email
        }
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

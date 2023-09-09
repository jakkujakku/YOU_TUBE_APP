//
//  LoginController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var mainLogoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFiedl: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    // 데이터 불러오기 -> 수정 필요
    func loadData() {
        if let item = AuthService.userDefaults.data(forKey: AuthService.userDafaultsKey) {
            do {
                AuthService.shared = try! JSONDecoder().decode([String: UserInfo].self, from: item)
                print("### \(AuthService.shared)")
            }
        }
    }

    @IBAction func tappedGoToLoginPage(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func tappedGoToSignUpPage(_ sender: Any) {
        let sb = UIStoryboard(name: "SignUp", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "RegisterController") as? RegisterController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

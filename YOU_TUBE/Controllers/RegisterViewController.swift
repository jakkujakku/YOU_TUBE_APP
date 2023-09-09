//
//  RegisterViewController.swift
//  YOU_TUBE
//
//  Created by clone1 on 2023/09/06.
//

import UIKit

class RegisterController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    var authServie = AuthService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "회원가입 페이지"
        signUpButton.isEnabled = true
    }

    @IBAction func tappedSignUpButton(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let item = UserInfo(name: name, email: email, password: password)
        authServie[name] = item

        // Userdefaults 저장
        let data = try? JSONEncoder().encode(authServie)
        AuthService.userDefaults.set(data, forKey: AuthService.userDafaultsKey)
        print("### \(authServie)")
//        navigationController?.popViewController(animated: true)
    }
}
